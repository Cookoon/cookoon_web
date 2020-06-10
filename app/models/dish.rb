class Dish < ApplicationRecord
  belongs_to :menu

  validates :name, presence: true
  validates :category, presence: true
  validates :order, presence: true, numericality: { greater_than: 0 }

  enum category: %i[aperitif amuse_bouches starter course entremets dessert]

  after_initialize do |dish|
    dish.order = count_dishes + 1
  end

  CATEGORIES = {
    aperitif: "Canapé",
    amuse_bouches: "Amuse-bouches",
    starter: "Entrée",
    course: "Plat",
    entremets: "Entremets",
    dessert: "Dessert",
  }.freeze

  private

  def count_dishes
    self.menu.dishes.count
  end
end
