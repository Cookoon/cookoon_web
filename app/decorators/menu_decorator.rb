class MenuDecorator < Draper::Decorator
  delegate_all

  def full_price_per_person_without_cents(people_count)
    h.money_without_cents_and_with_symbol object.price_with_tax_per_person(people_count)
  end
end
