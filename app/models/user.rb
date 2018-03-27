class User < ApplicationRecord
  include TimeRangeBuilder
  include StripeCustomerable

  scope :pending_invitation, -> { where.not(invitation_token: nil) }
  scope :invited_in_day_range_around, ->(date_time) { pending_invitation.where invitation_sent_at: day_range(date_time) }
  scope :joined_in_day_range_around, ->(date_time) { where invitation_accepted_at: day_range(date_time) }
  scope :missing_stripe_account, -> { where(stripe_account_id: nil) }
  scope :with_cookoon_created_in_day_range_around, ->(date_time) { joins(:cookoons).merge(Cookoon.created_in_day_range_around(date_time)).distinct }
  scope :with_reservation_in_day_range_around, ->(date_time) { joins(:reservations).merge(Reservation.created_in_day_range_around(date_time)).distinct }
  scope :with_reservation_finished_in_day_range_around, ->(date_time) { joins(:reservations).merge(Reservation.finished_in_day_range_around(date_time)).distinct }
  scope :has_cookoon, -> { joins(:cookoons).distinct }
  scope :has_no_cookoon, -> { left_outer_joins(:cookoons).where(cookoons: { id: nil }) }
  scope :discount_expired, -> { where('discount_expires_at < ?', Time.zone.now) }
  enum emailing_preferences: { no_emails: 0, all_emails: 1 }

  PHONE_REGEXP = /\A(\+\d+)?([\s\-\.]?\(?\d+\)?)+\z/

  devise :invitable, :database_authenticatable, :recoverable,
         :trackable, :validatable, :rememberable

  has_many :cookoons, dependent: :restrict_with_exception
  has_many :reservations, dependent: :restrict_with_exception
  has_many :reservation_requests, through: :cookoons, source: :reservations
  has_many :guests, dependent: :destroy
  has_many :user_searches, dependent: :destroy

  has_attachment :photo

  monetize :total_payouts_for_dashboard_cents
  monetize :discount_balance_cents

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number,
            presence: true,
            format: { with: PHONE_REGEXP }
  validates :terms_of_service, acceptance: { message: 'Vous devez accepter les conditions générales pour continuer' }

  after_invitation_accepted :send_welcome_email
  before_update :set_discount_expires_at, if: :discount_balance_cents_changed?

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    else
      'Membre Cookoon'
    end
  end

  def full_email
    Mail::Address.new("#{full_name} <#{email}>")
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

  def credit_cards
    User::CreditCards.new(self).list
  end

  def stripe_verified?
    return false unless stripe_account
    stripe_account.payouts_enabled
  end

  def active_recent_searches
    user_searches.active_recents
  end

  def current_search
    active_recent_searches.last
  end

  def total_payouts_for_dashboard_cents
    reservation_requests.passed.includes(:cookoon).sum(&:host_payout_price_cents)
  end

  def available_discount?
    discount_balance_cents.positive? && discount_expires_at&.future?
  end

  def send_reset_password_instructions
    if invited_to_sign_up?
      errors.add :email, :invitation_not_yet_accepted
    else
      super
    end
  end

  private

  def set_discount_expires_at
    return if discount_balance_cents < discount_balance_cents_was
    self.discount_expires_at = 2.months.from_now
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
