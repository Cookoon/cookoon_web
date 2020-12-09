module SearchAmexComponent
  extend ComponentHelper

  def types
    amex_types
  end

  private

  def amex_types
    [
      {data: 'amex_lunch', display: 'Déjeuner'},
      {data: 'amex_diner', display: 'Dîner'},
    ]
  end
end
