class User < ApplicationRecord
  include TimeRange

  scope :pending_invitation, -> { where.not(invitation_token: nil) }
  scope :invited_in_day_range_around, ->(date_time) { pending_invitation.where invitation_sent_at: day_range(date_time) }
  scope :joined_in_day_range_around, ->(date_time) { where invitation_accepted_at: day_range(date_time) }
  scope :missing_stripe_account, -> { where(stripe_account_id: nil) }
  scope :with_cookoon_created_in_day_range_around, ->(date_time) { joins(:cookoons).merge(Cookoon.created_in_day_range_around(date_time)).distinct }
  scope :with_reservation_in_day_range_around, ->(date_time) { joins(:reservations).merge(Reservation.created_in_day_range_around(date_time)).distinct }
  scope :with_reservation_finished_in_day_range_around, ->(date_time) { joins(:reservations).merge(Reservation.finished_in_day_range_around(date_time)).distinct }
  scope :has_cookoon, -> { joins(:cookoons).distinct }
  scope :has_no_cookoon, -> { left_outer_joins(:cookoons).where(cookoons: {id: nil}) }
  enum emailing_preferences: { all_off: 0, all_on: 1 }

  PHONE_REGEXP = /\A(\+\d+)?([\s\-\.]?\(?\d+\)?)+\z/

  devise :invitable, :database_authenticatable, :recoverable,
         :trackable, :validatable, :rememberable

  has_many :cookoons, dependent: :restrict_with_exception
  has_many :reservations, dependent: :restrict_with_exception
  has_many :reservation_requests, through: :cookoons, source: :reservations
  has_many :user_searches, dependent: :destroy

  has_attachment :photo

  monetize :total_payouts_for_dashboard_cents

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number,
            presence: true,
            format: {
              with: PHONE_REGEXP,
              message: :not_a_valid_phone_number
            }
  validates :terms_of_service, acceptance: { message: 'Vous devez accepter les conditions générales pour continuer' }

  after_invitation_accepted :send_welcome_email

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

  def stripe_verified?
    return false unless stripe_account
    stripe_account.payouts_enabled
  end

  def last_recent_search
    user_searches.recents.last
  end

  def total_payouts_for_dashboard_cents
    reservation_requests.passed.includes(:cookoon).sum(&:payout_price_for_host_cents)
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
