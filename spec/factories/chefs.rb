FactoryBot.define do
  factory :chef do
    before(:create) { Attachinary::File.define_method(:remove_temporary_tag) {} }

    name { "Gordon Ramsay" }
    description { "Un très bon chef" }
    citation { "Une cuisine parfaite" }
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
    gender { "male" }
    base_price { 500 }
    min_price { 0 }

    trait :with_min_price_instead_of_base_price do
      base_price { 0 }
      min_price { 600 }
    end
  end
end
