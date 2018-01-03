module Forest
  class User
    include ForestLiana::Collection

    collection 'User'

    field :full_name, type: 'String' do
      object.full_name
    end

    field :invited_by_full_name, type: 'String' do
      object.invited_by&.full_name
    end
  end
end
