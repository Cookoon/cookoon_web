class Service < ApplicationRecord
  belongs_to :reservation

  scope :payment_tied_to_reservation, -> { where(payment_tied_to_reservation: true) }

  delegate :cookoon, :user, to: :reservation

  monetize :unit_price_cents
  monetize :price_cents
  monetize :base_price_cents

  enum status: %i[quote paid]
  enum category: %i[special sommelier parking corporate catering breakfast flowers wine]

  before_create :set_price_cents, :set_name_from_category

  # validates :category, presence: true
  validates :category, uniqueness: { scope: :reservation }, unless: :wine?

  PRICES = {
    special: { base_price: 0, unit_price: 0, margin: 3 },
    sommelier: { base_price: 0, unit_price: 0, margin: 3 },
    parking: { base_price: 0, unit_price: 8250, margin: 1.25 },
    corporate: { base_price: 0, unit_price: 2500, margin: 1.25 },
    catering: { base_price: 0, unit_price: 3500, margin: 1.25 },
    breakfast: { base_price: 0, unit_price: 2500, margin: 3 },
    flowers: { base_price: 0, unit_price: 0, margin: 3 },
    wine: { base_price: 0, unit_price: 0, margin: 3 }
  }.freeze

  def payment(options = {})
    Service::Payment.new(self, options)
  end

  private

  def wine?
    self.category == "wine"
  end

  def set_price_cents
    return if sommelier? || special?
    self.price_cents = compute_price
  end

  def set_name_from_category
    case category
    when 'special'
      self.name = 'Personnalisé'
    when 'sommelier'
      self.name = 'Sommelier'
    when 'parking'
      self.name = 'Voiturier'
    when 'corporate'
      self.name = 'Kit professionnel'
    when 'catering'
      self.name = 'Plateaux repas'
    when 'breakfast'
      self.name = 'Petit déjeuner'
    when 'flowers'
      self.name = 'Composition florale'
    when 'wine'
      self.name = "Vin"
    end
  end

  def compute_price
    prices = PRICES[category.to_sym]
    if parking?
      prices[:base_price] + (prices[:unit_price] * reservation.duration)
    else
      prices[:base_price] + (prices[:unit_price] * reservation.people_count)
    end
  end
end
