# frozen_string_literal: true

module ProSearchComponent
  extend ComponentHelper

  def durations
    [
      {data: 3, display: '3h - pour une réunion ?'},
      {data: 5, display: '5h  - pour un déjeuner ou un board meeting ?'},
      {data: 7, display: '7h - pour un dîner ou une formation ?'},
      {data: 10, display: '10h - pour une journée de teambuilding ?'}
    ]
  end

  def people_counts
    (2..20)
  end
end
