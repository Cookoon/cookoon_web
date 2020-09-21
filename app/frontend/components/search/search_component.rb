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
      {data: 'lunch_cocktail', display: 'Cocktail déjeunatoire'},
      {data: 'diner', display: 'Dîner'},
      {data: 'diner_cocktail', display: 'Cocktail dînatoire'}
    ]
  end

  def business_types
    [
      # {data: 'breakfast', display: 'Petit-déjeuner'},
      {data: 'lunch', display: 'Déjeuner'},
      {data: 'lunch_cocktail', display: 'Cocktail déjeunatoire'},
      {data: 'diner', display: 'Dîner'},
      {data: 'diner_cocktail', display: 'Cocktail dînatoire'},
      # {data: 'morning', display: 'Matinée de travail'},
      # {data: 'day', display: 'Journée de travail'},
      # {data: 'afternoon', display: 'Après-midi de travail'}
    ]
  end
end
