FactoryBot.define do
  factory :chef_unavailability do
    available false
    date "2021-02-09"
    time_slot 1
    start_at "2021-02-09 14:17:18"
    end_at "2021-02-09 14:17:18"
    chef nil
  end
end
