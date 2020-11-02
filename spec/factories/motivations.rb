FactoryBot.define do
  factory :motivation do
    content "Je suis un épicurien"
    association :user
  end
end
