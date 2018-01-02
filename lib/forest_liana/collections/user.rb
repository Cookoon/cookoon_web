module Forest
  class User
    include ForestLiana::Collection

    collection 'User'

    field :full_name, type: 'String' do
      object.full_name
    end
    #
    # field :invited_by_full_name, type: 'String' do
    #   object.class.find(object.invited_by_id).full_name
    # end

    belongs_to :invited_by, reference: 'users.full_name' do
      object.class.find(object.invited_by_id)
    end
  end
end
