FactoryBot.define do
  factory :personal_taste do
    favorite_champagne "Roederer Brut Premier"
    favorite_wine "Côte Rôtie, Stéphane Ogier"
    favorite_restaurant_one "Guy Savoy"
    favorite_restaurant_two "Michel Sarran"
    favorite_restaurant_three "Frédéric Simonin"

    association :user
  end
end
