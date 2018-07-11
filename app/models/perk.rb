class Perk < ApplicationRecord
  belongs_to :cookoon
  belongs_to :perk_specification

  delegate :name, :icon_name, to: :perk_specification, allow_nil: true
end
