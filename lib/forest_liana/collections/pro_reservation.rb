module Forest
  class ProReservation
    include ForestLiana::Collection

    collection :Pro__Reservation

    action 'Propose Reservation', type: 'single', fields: [{
      field: 'message',
      type: 'String',
      description: 'The specific message you want to embed in the email',
      widget: 'text area'
    }]

    action 'Duplicate Reservation as draft', type: 'single'
  end
end
