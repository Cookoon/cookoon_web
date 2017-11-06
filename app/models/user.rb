class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,:recoverable,
    :trackable, :validatable, :rememberable

  has_many :cookoons
  has_many :reservations
  has_many :reservations_requests, through: :cookoons, source: :reservations
  has_many :user_searches

  has_attachment :photo

  def full_name
    if first_name && last_name
      "#{first_name.capitalize} #{last_name.capitalize}"
    else
      "Utilisateur Cookoon"
    end
  end

  def paid_reservations
    reservations.paid
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

  def total_payouts_for_dashboard
    price = reservations_requests.passed.sum { |request| request.payout_price_for_host }
    price.zero? ? Money.new(price) : price
  end
end
