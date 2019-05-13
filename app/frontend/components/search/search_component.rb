module SearchComponent
  extend ComponentHelper

  def types
    @reservation.business? ? business_types : customer_types
  end

  def people_counts
    (2..20)
  end

  private

  def customer_types
    [
      {data: 'brunch', display: 'Brunch'},
      {data: 'lunch', display: 'Déjeuner'},
      {data: 'diner', display: 'Dîner'},
      {data: 'cocktail', display: 'Cocktail'}
    ]
  end

  def business_types
    [
      {data: 'breakfast', display: 'Petit déjeuner'},
      {data: 'morning', display: 'Matinée de travail'},
      {data: 'day', display: 'Journée de travail'},
      {data: 'lunch', display: 'Déjeuner'},
      {data: 'afternoon', display: 'Après-midi de travail'},
      {data: 'diner', display: 'Dîner'},
      {data: 'cocktail', display: 'Cocktail'}
    ]
  end
end
