module Forest
  class ProReservation
    include ForestLiana::Collection

    collection :Pro__Reservation

    action 'Add Service from Specification', type: 'single', fields: [{
      field: 'service_specification_id',
      reference: 'Pro__ServiceSpecification.id',
      isRequired: true
    }, {
      field: 'quantity',
      type: 'Number',
      isRequired: true
    }]

    action 'Propose Reservation', type: 'single', fields: [{
      field: 'message',
      type: 'String',
      description: 'The specific message you want to embed in the email',
      widget: 'text area'
    }]

    action 'Duplicate Reservation as draft', type: 'single'
  end
end
