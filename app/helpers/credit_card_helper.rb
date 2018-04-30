module CreditCardHelper
  def display_credit_card_for(card_data)
    brand = card_data.brand.downcase
    brand = 'amex' if card_data.brand == 'American Express'
    "<i class='fab fa-cc-#{brand}' aria-hidden='true'></i> •••• #{card_data.last4}".html_safe
  end
end
