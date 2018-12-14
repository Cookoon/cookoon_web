FactoryBot.define do
  factory :pro_service, class: Pro::Service do
    name "Restauration"
    quantity 1
    association :reservation, factory: :pro_reservation
    unit_price_cents 10000
  end
end
