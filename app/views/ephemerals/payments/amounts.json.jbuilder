json.extract! @amounts, :discount
json.charge_amount humanized_money_with_symbol(@amounts[:charge_amount])
json.user_discount_balance humanized_money_with_symbol(@amounts[:user_discount_balance])