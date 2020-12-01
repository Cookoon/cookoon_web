class Menu < ApplicationRecord

  STATUSES = %w[initial active archived amex].freeze
  MEAL_TYPES = { "seated_meal" => "Repas assis", "standing_meal" => "Repas debout" }.freeze
  MAX_PER_CHEF = 2

  belongs_to :chef
  has_many :reservations, dependent: :nullify
  has_many :dishes, dependent: :destroy

  monetize :unit_price_cents

  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: Menu::STATUSES }
  validates :meal_type, presence: true, inclusion: { in: Menu::MEAL_TYPES.keys }

  # default_scope -> { order(unit_price_cents: :asc) }
  scope :order_by_asc_price, -> { order(unit_price_cents: :asc) }
  scope :order_by_meal_type, -> { order(meal_type: :asc) }
  scope :active, -> { where("status = 'active'") }
  scope :initial, -> { where("status = 'initial'") }
  scope :archived, -> { where("status = 'archived'") }
  scope :seated, -> { where("meal_type = 'seated_meal'") }
  scope :standing, -> { where("meal_type = 'standing_meal'") }
  scope :amex, -> { where("status = 'amex'") }

  def active?
    status == "active"
  end

  def archived?
    status == "archived"
  end

  def initial?
    status == "initial"
  end

  def amex?
    status == "amex"
  end

  def standing?
    meal_type == "standing_meal"
  end

  def seated?
    meal_type == "seated_meal"
  end

  def computed_price_with_margin
    compute_price_with_margin
  end

  def computed_price_with_margin_and_taxes
    compute_price_with_margin_and_taxes
  end

  def computed_price_with_chef_with_margin_per_person(people_count)
    compute_price_with_chef_with_margin(people_count) / people_count
  end

  def computed_price_with_chef_with_margin_and_taxes_per_person(people_count)
    compute_price_with_chef_with_margin_and_taxes(people_count) / people_count
  end

  private

  def computed_price_with_chef_with_margin(people_count)
    compute_price_with_chef_with_margin(people_count)
  end

  def computed_price_with_chef_with_margin_and_taxes(people_count)
    compute_price_with_chef_with_margin_and_taxes(people_count)
  end

  def compute_price_with_chef_with_margin(people_count)
    if chef.min_price.zero? # chef has base_price
      self.computed_price_with_margin * people_count + chef.computed_base_price_with_margin
    else
      [ self.computed_price_with_margin * people_count, chef.computed_min_price_with_margin ].max
    end
  end

  def compute_price_with_chef_with_margin_and_taxes(people_count)
    (1 + Reservation::TAX) * compute_price_with_chef_with_margin(people_count)
  end

  def compute_price_with_margin
    Money.new((1 + Reservation::MARGIN[:menu]) * (self.unit_price_cents))
  end

  def compute_price_with_margin_and_taxes
    (1 + Reservation::TAX) * compute_price_with_margin
  end

end
