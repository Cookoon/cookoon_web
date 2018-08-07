module Forest
  class ProQuote
    include ForestLiana::Collection

    collection :Pro__Quote

    action 'Create draft Reservation', type: 'single'
  end
end
