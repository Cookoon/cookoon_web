class ChefPerkSpecification < ApplicationRecord
  has_many :chef_perks, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
