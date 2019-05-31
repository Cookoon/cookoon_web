FactoryBot.define do
  factory :pro_reservation, class: Pro::Reservation do
    association :quote, factory: :pro_quote
    association :cookoon
    start_at { 10.days.from_now }
    duration { 2 }
    people_count { 6 }

    trait :draft do
      status { :draft }
    end

    trait :proposed do
      status { :proposed }
    end

    trait :modification_requested do
      status { :modification_requested }
    end

    trait :modification_processed do
      status { :modification_processed }
    end

    trait :accepted do
      status { :accepted }
    end

    trait :ongoing do
      status { :ongoing }
    end

    trait :passed do
      status { :passed }
    end
  end
end
