class PerkSpecification < ApplicationRecord
  validates :name, presence: true
  validates :icon_name, presence: true
  validates :name, uniqueness: true

  has_many :perks, dependent: :destroy

  EQUIPEMENTS = ['Écran', 'Système son', 'Chromecast', "Cuisine équipée", 'Apple TV']
  ACCESS = ['Accessible handicapé', 'Ascenseur']
  UNUSUALS = ["Jacuzzi", "Sauna", "Rooftop", "Piscine", "Oeuvres d'art", "Barbecue", "Cheminée"]
end
