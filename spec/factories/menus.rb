FactoryBot.define do
  factory :menu do
    association :chef
    description { "Menu d'hiver" }
    unit_price_cents { 5000 }
    meal_type { "seated_meal" }
  end
end
