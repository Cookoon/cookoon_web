class ChefPerkSpecification < ApplicationRecord
  has_many :perks, dependent: :destroy

  validates :name, presence: true
end
