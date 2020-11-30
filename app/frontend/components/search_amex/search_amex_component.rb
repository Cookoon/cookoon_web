module SearchAmexComponent
  extend ComponentHelper

  def types
    amex_types
  end

  private

  def amex_types
    [
      {data: 'lunch', display: 'Déjeuner'},
      {data: 'diner', display: 'Dîner'},
    ]
  end
end
