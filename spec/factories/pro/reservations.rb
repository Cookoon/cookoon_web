FactoryBot.define do
  factory :pro_reservation, class: Pro::Reservation do
    association :quote, factory: :pro_quote
    association :cookoon
    start_at 10.days.from_now
    duration 2
    people_count 6

    trait :created_two_days_ago do
      created_at 2.days.ago
    end

    trait :created_ten_days_ago do
      created_at 10.days.ago
    end
  end
end
