class Menu < ApplicationRecord
  belongs_to :chef

  monetize :unit_price_cents
end
