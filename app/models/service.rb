class Service < ApplicationRecord
  belongs_to :reservation

  scope :payment_tied_to_reservation, -> { where(payment_tied_to_reservation: true) }

  delegate :cookoon, :user, to: :reservation

  monetize :unit_price_cents
  monetize :price_cents
  monetize :base_price_cents

  CATEGORIES_WITH_FIXED_PRICE = %w[parking]
  # CATEGORIES_WITH_DISPLAYABLE_PRICE = %w[parking]
  # CATEGORIES_WITHOUT_DISPLAYABLE_PRICE = %w[special sommelier corporate catering breakfast flowers wine]

  # enum status: %i[initial quote captured paid]
  enum status: %i[initial validated payment_required captured paid]
  enum category: %i[special sommelier parking corporate catering breakfast flowers wine]

  default_scope -> { order(id: :asc) }

  before_create :set_name_and_default_prices, :compute_price, :set_status_validated_for_categories_with_fixed_price
  before_update :compute_price

  # validates :category, presence: true
  validates :category, uniqueness: { scope: :reservation }, unless: :wine?

  # scope :with_displayable_price, -> { where(category: CATEGORIES_WITH_DISPLAYABLE_PRICE) }
  # scope :without_displayable_price, -> { where(category: CATEGORIES_WITHOUT_DISPLAYABLE_PRICE) }
  scope :initial, -> { where(status: 'initial') }
  scope :not_initial, -> { where.not(status: 'initial') }

  def payment(options = {})
    Service::Payment.new(self, options)
  end

  def price_with_margin_and_taxes
    calculate_price_with_margin_and_taxes
  end

  def validate!
    set_validated_status!
  end

  def initial?
    status == "initial"
  end

  private

  def set_name_and_default_prices
    case category
    when 'special'
      # self.assign_attributes(
        assign_attributes(
        name: 'Personnalisé',
        quantity_base: 0,
        base_price: 0,
        quantity: 0,
        unit_price: 0,
        margin: 0.25
      )
    when 'sommelier'
      # self.assign_attributes(
        assign_attributes(
        name: 'Sommelier',
        quantity_base: 0,
        base_price: 0,
        quantity: sommelier_count,
        unit_price: 250,
        margin: 0.25,
      )
    when 'parking'
      # self.assign_attributes(
        assign_attributes(
        name: 'Voiturier',
        quantity_base: 1,
        base_price: 75,
        quantity: parking_count,
        unit_price: 60 * reservation.duration,
        margin: 0.25,
      )
    when 'corporate'
      # self.assign_attributes(
        assign_attributes(
        name: 'Kit professionnel',
        quantity_base: 1,
        base_price: 100,
        quantity: reservation.people_count,
        unit_price: 12,
        margin: 0.25,
      )
    when 'catering'
      # self.assign_attributes(
        assign_attributes(
        name: 'Plateaux repas',
        quantity_base: 1,
        base_price: 50,
        quantity: reservation.people_count,
        unit_price: 25,
        margin: 0.25,
      )
    when 'breakfast'
      # self.assign_attributes(
        assign_attributes(
        name: 'Petit-déjeuner',
        quantity_base: 1,
        base_price: 50,
        quantity: reservation.people_count,
        unit_price: 12,
        margin: 2,
      )
    when 'flowers'
      # self.assign_attributes(
        assign_attributes(
        name: 'Composition florale',
        quantity_base: 1,
        base_price: 50,
        quantity: 1,
        unit_price: 25,
        margin: 2,
      )
    when 'wine'
      # self.assign_attributes(
        assign_attributes(
        name: 'Vin',
        quantity_base: 0,
        base_price: 0,
        quantity: 1,
        unit_price: 25,
        margin: 2,
      )
    end
  end

  def set_validated_status!
    update_attributes(status: 'validated')
  end

  def sommelier_count
    return 1 unless reservation.people_count
    # 20 people per sommelier
    customer_per_sommelier = 20
    1 + ((reservation.people_count - 1) / customer_per_sommelier)
  end

  def parking_count
    return 1 unless reservation.people_count
    # 15 people per sommelier
    customer_per_voiturier = 15
    1 + ((reservation.people_count - 1) / customer_per_voiturier)
  end

  def wine?
    # self.category == "wine"
    category == "wine"
  end

  def compute_price
    # self.price = (1 + self.margin) * ((self.quantity_base * self.base_price) + (self.quantity * self.unit_price))
    assign_attributes(price: (1 + margin) * ((quantity_base * base_price) + (quantity * unit_price)))
  end

  def calculate_price_with_margin_and_taxes
    price * (1 + Reservation::PriceComputer::TAX )
  end

  def price_fixed?
    CATEGORIES_WITH_FIXED_PRICE.include?(category)
  end

  def set_status_validated_for_categories_with_fixed_price
    assign_attributes(status: 'validated') if price_fixed?
  end

end

# class Service < ApplicationRecord
#   belongs_to :reservation

#   scope :payment_tied_to_reservation, -> { where(payment_tied_to_reservation: true) }

#   delegate :cookoon, :user, to: :reservation

#   monetize :unit_price_cents
#   monetize :price_cents
#   monetize :base_price_cents

#   enum status: %i[quote paid]
#   enum category: %i[special sommelier parking corporate catering breakfast flowers wine]

#   before_create :set_price_cents, :set_name_from_category

#   # validates :category, presence: true
#   validates :category, uniqueness: { scope: :reservation }, unless: :wine?

#   PRICES = {
#     special: { base_price: 0, unit_price: 0, margin: 3 },
#     sommelier: { base_price: 0, unit_price: 0, margin: 3 },
#     parking: { base_price: 0, unit_price: 8250, margin: 1.25 },
#     corporate: { base_price: 0, unit_price: 2500, margin: 1.25 },
#     catering: { base_price: 0, unit_price: 3500, margin: 1.25 },
#     breakfast: { base_price: 0, unit_price: 2500, margin: 3 },
#     flowers: { base_price: 0, unit_price: 0, margin: 3 },
#     wine: { base_price: 0, unit_price: 0, margin: 3 }
#   }.freeze

#   def payment(options = {})
#     Service::Payment.new(self, options)
#   end

#   private

#   def wine?
#     self.category == "wine"
#   end

#   def set_price_cents
#     return if sommelier? || special?
#     self.price_cents = compute_price
#   end

#   def set_name_from_category
#     case category
#     when 'special'
#       self.name = 'Personnalisé'
#     when 'sommelier'
#       self.name = 'Sommelier'
#     when 'parking'
#       self.name = 'Voiturier'
#     when 'corporate'
#       self.name = 'Kit professionnel'
#     when 'catering'
#       self.name = 'Plateaux repas'
#     when 'breakfast'
#       self.name = 'Petit déjeuner'
#     when 'flowers'
#       self.name = 'Composition florale'
#     when 'wine'
#       self.name = "Vin"
#     end
#   end

#   def compute_price
#     prices = PRICES[category.to_sym]
#     if parking?
#       prices[:base_price] + (prices[:unit_price] * reservation.duration)
#     else
#       prices[:base_price] + (prices[:unit_price] * reservation.people_count)
#     end
#   end
# end
