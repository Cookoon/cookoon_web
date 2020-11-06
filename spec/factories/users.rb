FactoryBot.define do
  factory :user do
    # after(:build) do |user|
    #   user.build_job(user: user, job_title: "Développeur", company: "Cookoon", linkedin_profile: "https://www.linkedin.com/in/alice-fabre-676211182/")
    # end
    before(:create) { Attachinary::File.define_method(:remove_temporary_tag) {} }
    first_name { 'Aaron' }
    last_name { 'Sumner' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    phone_number { '0636686565' }
    password { 'plopplop' }
    address { "8 rue de la Vrillière, Paris" }
    photo {
      <<~CLOUDINARY
        [
          {\"public_id\":\"tlukyujdrwp7krc6setx\",\"version\":1520416362,\"signature\":\"863d76cc03532aa5201a419b99555bdb10291428\",\"width\":512,\"height\":512,\"format\":\"png\",\"resource_type\":\"image\",\"created_at\":\"2018-03-07T09:52:42Z\",\"tags\":[\"development_env\",\"attachinary_tmp\"],\"bytes\":38308,\"type\":\"upload\",\"etag\":\"e44c8191e4b29efa962ebbb826f0801a\",\"placeholder\":false,\"url\":\"http://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"secure_url\":\"https://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"original_filename\":\"ic_launcher-web\"}
        ]
      CLOUDINARY
    }

    trait :with_stripe_account do
      stripe_account_id { 'acct_1BdgAdJBhuyFUZoA' }
    end

    trait :with_job do
      after(:build) do |user|
        user.build_job(user: user, job_title: "Développeur", company: "Cookoon", linkedin_profile: "https://www.linkedin.com/in/alice-fabre-676211182/")
      end
    end

    trait :with_personal_taste do
      after(:build) do |user|
        user.build_personal_taste(user: user, favorite_champagne: "Roederer Brut Premier", favorite_wine: "Côte Rôtie, Stéphane Ogier", favorite_restaurant_one: "Guy Savoy", favorite_restaurant_two: "Michel Sarran", favorite_restaurant_three: "Frédéric Simonin")
      end
    end

    trait :with_motivation do
      after(:build) do |user|
        user.build_motivation(user: user, content: "Je suis épicurien.")
      end
    end

  end
end
