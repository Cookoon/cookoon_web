class ChefPerkSpecification < ApplicationRecord
  has_many :chef_perks, dependent: :destroy

  has_attachment :image

  validates :name, presence: true, uniqueness: true
  validates :image, presence: true
end
