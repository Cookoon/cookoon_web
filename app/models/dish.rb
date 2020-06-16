class Dish < ApplicationRecord
  belongs_to :menu

  validates :name, presence: true
  validates :category, presence: true
  validates :order, presence: true, numericality: { greater_than: 0 }

  CATEGORIES = %w[Apéritif Amuse-bouches Entrée Plat Entremets Dessert].freeze

end
