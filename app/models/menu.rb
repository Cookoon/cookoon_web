class Menu < ApplicationRecord

  STATUSES = %w[initial active archived].freeze
  MAX_PER_CHEF = 2

  belongs_to :chef
  has_many :reservations, dependent: :nullify
  has_many :dishes, dependent: :destroy

  monetize :unit_price_cents

  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: Menu::STATUSES }

  default_scope -> { order(unit_price_cents: :asc) }
  scope :active, -> { where("status = 'active'") }
  scope :initial, -> { where("status = 'initial'") }
  scope :archived, -> { where("status = 'archived'") }

  def active?
    status == "active"
  end

  def archived?
    status == "archived"
  end

  def initial?
    status == "initial"
  end

  def computed_price_with_margin
    compute_price_with_margin
  end

  def computed_price_with_margin_and_taxes
    compute_price_with_margin_and_taxes
  end

  private

  def compute_price_with_margin
    Money.new((1 + Reservation::MARGIN[:menu]) * (self.unit_price_cents))
  end

  def compute_price_with_margin_and_taxes
    (1 + Reservation::TAX) * compute_price_with_margin
  end

end
