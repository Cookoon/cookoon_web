FactoryBot.define do
  factory :cookoon do
    after(:build) { |cookoon| cookoon.define_singleton_method(:geocode) {} }
    after(:build) do |cookoon|
      cookoon.perks.build(cookoon: cookoon, perk_specification: build(:perk_specification))
    end
    before(:create) { Attachinary::File.define_method(:remove_temporary_tag) {} }

    association :user, :with_job
    name { 'Grand Salon 1930 - Silicon Sentier' }
    surface { 100 }
    price { 3000 }
    address { "85 rue d'Aboukir, 75002 Paris" }
    capacity { 8 }
    capacity_standing { 16 }
    category { 'Appartement' }
    photos {
      <<~CLOUDINARY
        [
          {\"public_id\":\"tlukyujdrwp7krc6setx\",\"version\":1520416362,\"signature\":\"863d76cc03532aa5201a419b99555bdb10291428\",\"width\":512,\"height\":512,\"format\":\"png\",\"resource_type\":\"image\",\"created_at\":\"2018-03-07T09:52:42Z\",\"tags\":[\"development_env\",\"attachinary_tmp\"],\"bytes\":38308,\"type\":\"upload\",\"etag\":\"e44c8191e4b29efa962ebbb826f0801a\",\"placeholder\":false,\"url\":\"http://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"secure_url\":\"https://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"original_filename\":\"ic_launcher-web\"},
          {\"public_id\":\"tlukyujdrwp7krc6setx\",\"version\":1520416362,\"signature\":\"863d76cc03532aa5201a419b99555bdb10291428\",\"width\":512,\"height\":512,\"format\":\"png\",\"resource_type\":\"image\",\"created_at\":\"2018-03-07T09:52:42Z\",\"tags\":[\"development_env\",\"attachinary_tmp\"],\"bytes\":38308,\"type\":\"upload\",\"etag\":\"e44c8191e4b29efa962ebbb826f0801a\",\"placeholder\":false,\"url\":\"http://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"secure_url\":\"https://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"original_filename\":\"ic_launcher-web\"},
          {\"public_id\":\"tlukyujdrwp7krc6setx\",\"version\":1520416362,\"signature\":\"863d76cc03532aa5201a419b99555bdb10291428\",\"width\":512,\"height\":512,\"format\":\"png\",\"resource_type\":\"image\",\"created_at\":\"2018-03-07T09:52:42Z\",\"tags\":[\"development_env\",\"attachinary_tmp\"],\"bytes\":38308,\"type\":\"upload\",\"etag\":\"e44c8191e4b29efa962ebbb826f0801a\",\"placeholder\":false,\"url\":\"http://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"secure_url\":\"https://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"original_filename\":\"ic_launcher-web\"},
          {\"public_id\":\"tlukyujdrwp7krc6setx\",\"version\":1520416362,\"signature\":\"863d76cc03532aa5201a419b99555bdb10291428\",\"width\":512,\"height\":512,\"format\":\"png\",\"resource_type\":\"image\",\"created_at\":\"2018-03-07T09:52:42Z\",\"tags\":[\"development_env\",\"attachinary_tmp\"],\"bytes\":38308,\"type\":\"upload\",\"etag\":\"e44c8191e4b29efa962ebbb826f0801a\",\"placeholder\":false,\"url\":\"http://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"secure_url\":\"https://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"original_filename\":\"ic_launcher-web\"}
        ]
      CLOUDINARY
    }
    main_photo {
      <<~CLOUDINARY
        [
          {\"public_id\":\"tlukyujdrwp7krc6setx\",\"version\":1520416362,\"signature\":\"863d76cc03532aa5201a419b99555bdb10291428\",\"width\":512,\"height\":512,\"format\":\"png\",\"resource_type\":\"image\",\"created_at\":\"2018-03-07T09:52:42Z\",\"tags\":[\"development_env\",\"attachinary_tmp\"],\"bytes\":38308,\"type\":\"upload\",\"etag\":\"e44c8191e4b29efa962ebbb826f0801a\",\"placeholder\":false,\"url\":\"http://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"secure_url\":\"https://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"original_filename\":\"ic_launcher-web\"}
        ]
      CLOUDINARY
    }
    long_photo {
      <<~CLOUDINARY
        [
          {\"public_id\":\"tlukyujdrwp7krc6setx\",\"version\":1520416362,\"signature\":\"863d76cc03532aa5201a419b99555bdb10291428\",\"width\":512,\"height\":512,\"format\":\"png\",\"resource_type\":\"image\",\"created_at\":\"2018-03-07T09:52:42Z\",\"tags\":[\"development_env\",\"attachinary_tmp\"],\"bytes\":38308,\"type\":\"upload\",\"etag\":\"e44c8191e4b29efa962ebbb826f0801a\",\"placeholder\":false,\"url\":\"http://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"secure_url\":\"https://res.cloudinary.com/cookoon-dev/image/upload/v1520416362/tlukyujdrwp7krc6setx.png\",\"original_filename\":\"ic_launcher-web\"}
        ]
      CLOUDINARY
    }
    citation { "Un coin de verdure dans Paris" }
    description { "Au sommet d'un des plus hauts immeubles des batignolles, l'appartement de Laura & Grégory offre une vue à 180 ° sur tout Paris, de Montmartre à la Tour Eiffel. Il pourra ainsi aussi bien accueillir une réunion de travail pour 6 personnes, un dîner entre amis ou un tête à tête romantique." }

    trait :with_photos_upload do
      photo_urls { %w[https://picsum.photos/400/300 https://picsum.photos/400/300] }
    end

    trait :without_perks do
      after(:build) do |cookoon|
        cookoon.perks.delete_all
      end
    end
  end
end
