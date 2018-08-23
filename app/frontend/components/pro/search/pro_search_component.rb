# frozen_string_literal: true

module ProSearchComponent
  extend ComponentHelper

  def durations
    [
      {data: 2, display: 'une réunion (2 heures)'},
      {data: 4, display: 'un comité (4 heures)'},
      {data: 5, display: 'demi-journée (5 heures)'},
      {data: 10, display: 'journée complète (10 heures)'}
    ]
  end

  def people_counts
    (2..20)
  end
end
