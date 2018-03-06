FactoryBot.define do
  factory :cookoon do
    association :user
    name 'Grand Salon 1930 - Silicon Sentier'
    surface 100
    price 3000
    address "85 rue d'Aboukir, 75002 Paris"
    capacity 8
    category 'Appartement'

    trait :with_photos_upload do
      photo_urls %w[https://picsum.photos/400/300]
    end
  end
end
