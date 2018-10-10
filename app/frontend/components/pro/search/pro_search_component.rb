# frozen_string_literal: true

module ProSearchComponent
  extend ComponentHelper

  def durations
    [
      {data: 3, display: 'une réunion (3 heures)'},
      {data: 5, display: 'un comité (5 heures)'},
      {data: 7, display: 'demi-journée (7 heures)'},
      {data: 10, display: 'journée complète (10 heures)'}
    ]
  end

  def people_counts
    (2..20)
  end
end
