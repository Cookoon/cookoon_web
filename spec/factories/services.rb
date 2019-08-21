FactoryBot.define do
  factory :service, class: Service do
    name { 'Restauration' }
    association :reservation,
    price_cents { 10000 }
  end
end