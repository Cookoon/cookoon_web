json.extract! @amounts, :discount
json.discount_amount humanized_money_with_symbol(@amounts[:discount_amount])
json.charge_amount humanized_money_with_symbol(@amounts[:charge_amount])
json.user_discount_balance humanized_money_with_symbol(@amounts[:user_discount_balance])
json.services_count @amounts[:services_count]
json.html render partial: 'reservations/services_prices.html.erb'
