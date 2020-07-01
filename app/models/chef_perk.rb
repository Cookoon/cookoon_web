class ChefPerk < ApplicationRecord
  belongs_to :chef
  belongs_to :chef_perk_specification

  validates :order, numericality: { greater_than: 0 }
end
