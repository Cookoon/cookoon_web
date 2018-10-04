FactoryBot.define do
  factory :pro_quote, class: Pro::Quote do
    association :user
    association :company
    start_at 10.days.from_now
    duration 4
    people_count 6
  end
end
