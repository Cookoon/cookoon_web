class Perk < ApplicationRecord
  belongs_to :cookoon
  belongs_to :perk_specification
end
