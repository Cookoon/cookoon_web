json.extract! @amounts, :discount
json.services_price humanized_money_with_symbol(@amounts[:services_price])
json.discount_amount humanized_money_with_symbol(@amounts[:discount_amount])
json.charge_amount humanized_money_with_symbol(@amounts[:charge_amount])
json.user_discount_balance humanized_money_with_symbol(@amounts[:user_discount_balance])