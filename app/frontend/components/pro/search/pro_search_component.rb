# frozen_string_literal: true

module ProSearchComponent
  extend ComponentHelper

  def durations
    [
      {data: 4, display: '4h - pour un petit déjeuner'},
      {data: 5, display: '5h  - pour un déjeuner ou un brunch'},
      {data: 7, display: '7h - pour un grand dîner avec chef'},
      {data: 10, display: "10h - pour un comité d'entreprise"},
      {data: 12, display: '12h - pour une journée de séminaire'}
    ]
  end

  def people_counts
    (2..20)
  end
end
