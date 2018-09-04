module Forest
  class ProReservation
    include ForestLiana::Collection

    collection :Pro__Reservation

    action 'Propose Reservation', type: 'single'
  end
end
