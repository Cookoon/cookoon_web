FactoryBot.define do
  factory :perk do
    association :cookoon
    association :perk_specification, strategy: :build
    # strategy: :build prevent the system to create a new perk specification with same name, which will raise an error
    # cookoon { nil }
    # perk_specification { nil }
    quantity { 1 }
  end
end
