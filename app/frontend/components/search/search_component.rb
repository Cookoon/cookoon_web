module SearchComponent
  extend ComponentHelper

  def types
    [
      {data: 'brunch', display: 'Brunch'},
      {data: 'lunch', display: 'Déjeuner'},
      {data: 'diner', display: 'Dîner'},
      {data: 'cocktail', display: 'Cocktail'}
    ]
  end

  def people_counts
    (2..20)
  end
end
