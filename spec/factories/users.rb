FactoryBot.define do
  factory :user do
    first_name { 'Aaron' }
    last_name { 'Sumner' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    phone_number { '0636686565' }
    password { 'plopplop' }
    address { "8 rue de la Vrillière, Paris" }

    trait :with_stripe_account do
      stripe_account_id { 'acct_1BdgAdJBhuyFUZoA' }
    end
  end
end
