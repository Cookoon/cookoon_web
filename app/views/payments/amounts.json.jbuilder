json.charge_amount humanized_money_with_symbol(@amounts[:charge_amount])
json.services_count @amounts[:services_count]
json.html render partial: 'reservations/services_prices.html.erb'
