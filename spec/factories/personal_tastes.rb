FactoryBot.define do
  factory :personal_taste do
    favorite_wines "Roederer Brut Premier / Côte Rôtie, Stéphane Ogier"
    favorite_restaurants "Guy Savoy, Michel Sarran, Frédéric Simonin"

    association :user
  end
end
