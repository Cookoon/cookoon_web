module SearchComponent
  extend ComponentHelper

  def durations
    [
      {data: 4, display: 'Brunch'},
      {data: 5, display: 'Déjeuner'},
      {data: 7, display: 'Dîner'},
      {data: 7, display: 'Cocktail'}
    ]
  end

  def people_counts
    (2..20)
  end
end
