class PerkSpecification < ApplicationRecord
  validates :name, presence: true
  validates :icon_name, presence: true
end
