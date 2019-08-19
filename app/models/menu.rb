class Menu < ApplicationRecord
  belongs_to :chef
  has_many :reservations, dependent: :nullify

  monetize :unit_price_cents
end
