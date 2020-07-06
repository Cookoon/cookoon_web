class ChefPerk < ApplicationRecord
  belongs_to :chef
  belongs_to :chef_perk_specification

  delegate :name, to: :chef_perk_specification, allow_nil: true

  validates :chef_perk_specification_id, presence: true, uniqueness: true
end
