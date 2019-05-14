FactoryBot.define do
  factory :reservation do
    association :cookoon
    association :user
    start_at 10.days.from_now
    people_count 6
    type_name 'brunch'

    trait :paid do
      paid true
    end

    trait :created_two_days_ago do
      created_at 2.days.ago
    end

    trait :created_ten_days_ago do
      created_at 10.days.ago
    end
  end
end
