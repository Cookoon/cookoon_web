FactoryBot.define do
  factory :service, class: Service do
    name { 'Restauration' }
    association :reservation
  end
end