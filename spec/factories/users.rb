FactoryBot.define do
  factory :user do
    first_name 'Aaron'
    last_name 'Sumner'
    sequence(:email) { |n| "tester#{n}@example.com" }
    phone_number '0636686565'
    password 'plopplop'
  end
end
