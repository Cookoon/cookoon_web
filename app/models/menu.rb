class Menu < ApplicationRecord
  belongs_to :chef
  has_many :reservations, dependent: :nullify
  has_many :dishes, dependent: :destroy

  monetize :unit_price_cents

  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
end
