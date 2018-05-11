class Service < ApplicationRecord
  belongs_to :reservation

  scope :payment_tied_to_reservation, -> { where(payment_tied_to_reservation: true) }

  delegate :cookoon, :user, to: :reservation

  monetize :price_cents, disable_validation: true
  monetize :payment_amount_cents, disable_validation: true
  monetize :discount_amount_cents

  enum status: %i[quote paid]
  enum category: %i[special catering chef corporate]

  before_create :set_price_cents

  validates :category, presence: true
  validates :category, uniqueness: { scope: :reservation }

  # TODO: FC 09may18 refactor payments_controller#display_options_for(category) to use DISPLAY?
  DISPLAY = {
    corporate: { icon_name: 'pro', mail_display_name: 'Kit professionnel' },
    chef: { icon_name: 'chef', mail_display_name: 'Chef à domicile' },
    catering: { icon_name: 'food', mail_display_name: 'Plateaux repas' },
    special: { icon_name: 'concierge', mail_display_name: 'Demande spéciale' }
  }.freeze

  # TODO: SET ACTUAL PRICES
  PRICES = {
    catering: { base_price: 0, unit_price: 2000 },
    chef: { base_price: 0, unit_price: 4000 },
    corporate: { base_price: 2000, unit_price: 1000 }
  }.freeze

  def payment(options = {})
    Service::Payment.new(self, options)
  end

  def payment_amount_cents
    price_cents
  end

  private

  def set_price_cents
    return if special?
    self.price_cents = compute_price
  end

  def compute_price
    prices = PRICES[category.to_sym]
    prices[:base_price] + (prices[:unit_price] * reservation.people_count)
  end
end
