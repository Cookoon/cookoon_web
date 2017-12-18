module Forest
  class User
    include ForestLiana::Collection

    collection 'User'

    field :full_name, type: 'String' do
      "#{object.first_name} #{object.last_name}"
    end
  end
end
