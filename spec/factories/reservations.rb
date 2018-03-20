FactoryBot.define do
  factory :reservation do
    association :cookoon
    association :user
    start_at Time.zone.now.in(10.days)
    duration 2
  end
end
