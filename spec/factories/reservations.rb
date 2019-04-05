FactoryBot.define do
  factory :reservation do
    association :cookoon
    association :user
    start_at { 10.days.from_now }
    duration { 2 }

    trait :paid do
      status { :paid }
    end

    trait :created_two_days_ago do
      created_at { 2.days.ago }
    end

    trait :created_ten_days_ago do
      created_at { 10.days.ago }
    end
  end
end
