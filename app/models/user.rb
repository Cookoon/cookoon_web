class User < ApplicationRecord
  PHONE_REGEXP = /\A(\+\d+)?([\s\-\.]?\(?\d+\)?)+\z/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable,
         :trackable, :validatable, :rememberable

  has_many :cookoons
  has_many :reservations
  has_many :reservation_requests, through: :cookoons, source: :reservations
  has_many :user_searches

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

  def full_name
    if first_name && last_name
      "#{first_name.capitalize} #{last_name.capitalize}"
    else
      'Utilisateur Cookoon'
    end
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
end
