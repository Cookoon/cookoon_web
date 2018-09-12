module Forest
  class ProReservation
    include ForestLiana::Collection

    collection :Pro__Reservation

    action 'Propose Reservation', type: 'single'
    action 'Duplicate Reservation as draft', type: 'single'
  end
end
