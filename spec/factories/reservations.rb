FactoryBot.define do
  factory :reservation do
    association :cookoon
    association :user, :with_job, :with_personal_taste, :with_motivation
    start_at 10.days.from_now
    people_count 6
    type_name 'breakfast'

    trait :paid do
      paid true
    end

    trait :charged do
      aasm_state "charged"
    end

    trait :created_two_days_ago do
      created_at { 2.days.ago }
    end

    trait :created_ten_days_ago do
      created_at { 10.days.ago }
    end

    trait :with_menu do
      association :menu
    end

    trait :with_two_services do
      type_name 'diner'
      after(:build) do |reservation|
        reservation.services.build([{reservation: reservation}, {reservation: reservation, name: 'wine'}])
        # reservation.services.build(reservation: reservation)
        # reservation.services.build(reservation: reservation, name: 'wine')
      end
    end
  end
end
