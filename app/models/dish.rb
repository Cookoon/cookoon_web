class Dish < ApplicationRecord
  belongs_to :menu

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: %w(aperitif amuse_bouches starter course entremets dessert) }
  validates :order, presence: true, numericality: { greater_than: 0 }

  CATEGORIES = [
    [ "Canapé", :aperitif ],
    [ "Amuse-bouches", :amuse_bouches ],
    [ "Entrée", :starter ],
    [ "Plat", :course ],
    [ "Entremets", :entremets ],
    [ "Dessert", :dessert ],
  ].freeze

  FRENCH_CATEGORIES = {
    aperitif: "Canapé",
    amuse_bouches: "Amuse-bouches",
    starter: "Entrée",
    course: "Plat",
    entremets: "Entremets",
    dessert: "Dessert",
  }.freeze

end
