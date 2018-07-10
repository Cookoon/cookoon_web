class PerkSpecification < ApplicationRecord
  validates :name, presence: true
  validates :icon_name, presence: true

  has_many :perks, dependent: :destroy
end
