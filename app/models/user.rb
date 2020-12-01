class User < ApplicationRecord
  include TimeRangeBuilder
  include Stripe::Customerable
  class NotProError < StandardError; end

  attr_accessor :skip_password_validation

  scope :pending_invitation, -> { where.not(invitation_token: nil) }
  scope :invited_in_day_range_around, ->(date_time) { pending_invitation.where invitation_sent_at: day_range(date_time) }
  scope :joined_in_day_range_around, ->(date_time) { where invitation_accepted_at: day_range(date_time) }
  scope :missing_stripe_account, -> { where(stripe_account_id: nil) }
  scope :with_stripe_account, -> { where.not(stripe_account_id: nil) }
  scope :with_cookoon_created_in_day_range_around, ->(date_time) { joins(:cookoons).merge(Cookoon.created_in_day_range_around(date_time)).distinct }
  scope :with_reservation_in_day_range_around, ->(date_time) { joins(:reservations).merge(Reservation.created_in_day_range_around(date_time)).distinct }
  scope :with_reservation_finished_in_day_range_around, ->(date_time) { joins(:reservations).merge(Reservation.finished_in_day_range_around(date_time)).distinct }
  scope :has_cookoon, -> { joins(:cookoons).distinct }
  scope :has_no_cookoon, -> { left_outer_joins(:cookoons).where(cookoons: { id: nil }) }
  scope :membership_asking, -> { where(membership_asking: true) }
  enum emailing_preferences: { no_emails: 0, all_emails: 1 }

  PHONE_REGEXP = /\A(\+\d+)?([\s\-\.]?\(?\d+\)?)+\z/
  TERMS_OF_SERVICE_DATE = DateTime.new(2020, 9, 30, 14, 00, 00)

  devise :invitable, :database_authenticatable, :recoverable,
         :trackable, :validatable, :rememberable

  belongs_to :company, required: false
  has_many :cookoons, dependent: :restrict_with_exception
  has_many :reservations, dependent: :restrict_with_exception
  has_many :reservation_requests, through: :cookoons, source: :reservations
  has_one :job, dependent: :destroy
  has_one :personal_taste, dependent: :destroy
  has_one :motivation, dependent: :destroy
  accepts_nested_attributes_for :job
  accepts_nested_attributes_for :personal_taste
  accepts_nested_attributes_for :motivation
  has_one :amex_code

  has_attachment :photo

  monetize :total_payouts_for_dashboard_cents

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number,
            presence: true,
            format: { with: PHONE_REGEXP }
  validates :born_on, presence: true, if: :invited_to_sign_up?, unless: :amex?
  validates :terms_of_service, acceptance: { message: 'Vous devez accepter les conditions générales de services pour continuer' }, unless: :amex?
  validates :address, presence: true, on: :create, unless: :amex?
  validates :job, presence: true, on: :create, unless: :amex?
  validates :personal_taste, presence: true, on: :create, unless: :amex?
  validates :motivation, presence: true, on: :create, unless: :amex?
  validates :photo, presence: true, on: :create, unless: :amex?

  after_invitation_accepted :send_welcome_email
  after_save :upsert_mailchimp_subscription, if: :saved_change_to_born_on?
  before_update :report_to_slack, if: :stripe_account_id_changed?
  after_create :report_to_slack_new_membership_asking, if: :saved_change_to_membership_asking?

  alias_attribute :customerable_label, :email

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name.capitalize} #{last_name.capitalize}"
    else
      'Membre Cookoon'
    end
  end

  def full_email
    Mail::Address.new("#{full_name} <#{email}>")
  end

  def pro?
    company.present?
  end

  def notifiable_reservations
    reservations.accepted
  end

  def notifiable_reservation_requests
    reservation_requests.paid
  end

  def stripe_account
    @stripe_account ||= StripeAccountService.new(user: self).retrieve_stripe_account
  end

  def credit_card
    @credit_card ||= User::CreditCards.new(self)
  end

  def credit_cards
    credit_card.list
  end

  def stripe_verified?
    # return false unless stripe_account
    # stripe_account.payouts_enabled
    stripe_account.present?
  end

  def total_payouts_for_dashboard_cents
    reservation_requests.passed.includes(:cookoon).sum(&:host_payout_price_cents)
  end

  def send_reset_password_instructions
    if invited_to_sign_up?
      errors.add :email, :invitation_not_yet_accepted
    elsif membership_asking?
      errors.add :email, :membership_asking_not_yet_accepted
    else
      super
    end
  end

  def reached_max_cookoons_count?
    cookoons.count >= Cookoon::MAX_PER_USER
  end

  def stripe_bank_account?
    stripe_account? && stripe_account.external_accounts.present?
  end

  def stripe_bank_account_name
    stripe_bank_account.data.first.bank_name
  end

  def stripe_bank_account_last_four
    stripe_bank_account.data.first.last4
  end

  def stripe_account_requirements_currently_due?
    stripe_account? && stripe_account.requirements.currently_due.present?
  end

  def stripe_account_requirements_currently_due
    return false unless stripe_account_requirements_currently_due?
    stripe_account.requirements.currently_due
  end

  def stripe_account_identity_requirements?
    return false unless stripe_account_requirements_currently_due?
    stripe_account_identity_requirements = ["business_profile.url", "individual.verification.additional_document", "individual.verification.document"]
    stripe_account_requirements_currently_due.any? {|requirement| stripe_account_identity_requirements.include?(requirement)}
  end

  def payment(options = {})
    @payment ||= User::Payment.new(self, options)
  end

  def send_membership_asking_email
    UserMailer.membership_asking_email(self).deliver_later
  end

  def send_inscription_payment_email
    UserMailer.inscription_payment_email(self).deliver_later
  end

  def report_to_slack_inscription_payment
    # return unless Rails.env.production?
    return if Rails.env.development?
    PingSlackInscriptionPaymentJob.perform_later(id)
  end

  private

  def membership_asking?
    membership_asking == true
  end

  def password_required?
    return false if skip_password_validation
    super
  end

  def report_to_slack
    return unless Rails.env.production?
    PingSlackHostJob.perform_later(id)
  end

  def report_to_slack_new_membership_asking
    # return unless Rails.env.production?
    return if Rails.env.development? #comment + perform_now to get it in development
    PingSlackUserJob.perform_later(id)
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end

  def upsert_mailchimp_subscription
    body = {
      email_address: email,
      status: 'subscribed',
      merge_fields: {
        FIRST_NAME: first_name,
        LAST_NAME: last_name,
        BORN_ON: born_on&.to_s,
        BIRTHDAY: born_on&.strftime('%m/%d')
      },
      interests: {
        "1fb3f8668d"=> cookoons.approved.any?, # Groupe Hôtes
        "b58fb2d731"=> pro? # Groupe Business
      }
    }
    UpsertMailchimpSubscriptionJob.perform_later(email, ENV['MAILCHIMP_LIST_ID'], body)
  end

  def stripe_bank_account
    stripe_account.external_accounts
  end

  def stripe_account?
    stripe_account.present?
  end

  def amex?
    amex
  end
end
