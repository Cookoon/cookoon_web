FactoryBot.define do
  factory :user do
    # after(:build) do |user|
    #   user.build_job(user: user, job_title: "Développeur", company: "Cookoon", linkedin_profile: "https://www.linkedin.com/in/alice-fabre-676211182/")
    # end
    first_name { 'Aaron' }
    last_name { 'Sumner' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    phone_number { '0636686565' }
    password { 'plopplop' }
    address { "8 rue de la Vrillière, Paris" }

    trait :with_stripe_account do
      stripe_account_id { 'acct_1BdgAdJBhuyFUZoA' }
    end

    trait :with_job do
      after(:build) do |user|
        user.build_job(user: user, job_title: "Développeur", company: "Cookoon", linkedin_profile: "https://www.linkedin.com/in/alice-fabre-676211182/")
      end
    end

  end
end
