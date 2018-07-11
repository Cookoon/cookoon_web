module Forest
  class Cookoon
    include ForestLiana::Collection

    collection :Cookoon

    field :all_perks, type: 'String' do
      object.list_perks
    end
  end
end
