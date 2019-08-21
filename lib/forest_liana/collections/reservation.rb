module Forest
  class Reservation
    include ForestLiana::Collection

    collection :Reservation

    action 'Cancel by host', fields: [{
      field: 'confirmed',
      type: 'Boolean',
      description: 'Are you sure?',
      is_required: true,
      defaultValue: false
    }]

    action 'Create Service', fields: [
      {
        field: 'content',
        type: 'String',
        description: 'Content / description',
        is_required: true,
        widget: 'rich text editor'
      },
      {
        field: 'price',
        type: 'Number',
        description: 'Price in €, ex. 99,99',
        is_required: true
      }
    ]
  end
end
