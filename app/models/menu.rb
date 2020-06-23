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

  def active?
    status == "active"
  end

  def archived?
    status == "archived"
  end

  def initial?
    status == "initial"
  end

end
