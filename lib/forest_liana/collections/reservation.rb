module Forest
  class Reservation
    include ForestLiana::Collection

    collection :Reservation

    action 'Cancel by host', fields: [{
      field: 'confirmed',
      type: 'Boolean',
      description: 'Are you sure?',
      isRequired: true,
      defaultValue: false
    }]
  end
end
