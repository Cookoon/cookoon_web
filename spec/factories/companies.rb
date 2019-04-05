FactoryBot.define do
  factory :company do
    name { 'Réceptions nouvelles' }
    address { '12 rue lincoln - 75008 Paris' }
    referent_email { 'quentin@cookoon.fr' }

    after(:build) { |company| company.class.skip_callback(:create, :after, :stripe_prepare, raise: false) }

    factory :with_stripe_prepare do
      after(:create) { |company| company.send(:stripe_prepare) }
    end

    trait :with_valid_siren do
      siren { '821 316 239' }
    end

    trait :with_valid_siret do
      siret { '82131623900010' }
    end

    trait :with_invalid_siren do
      siren { '821 316' }
    end

    trait :with_invalid_siret do
      siret { '82131620' }
    end
  end
end
