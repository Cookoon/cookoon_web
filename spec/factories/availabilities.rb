FactoryBot.define do
  factory :availability do
    association :cookoon
    date Date.current
    time_slot :morning
  end
end
