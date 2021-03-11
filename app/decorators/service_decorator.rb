class ServiceDecorator < Draper::Decorator
  delegate_all

  def full_price
    h.humanized_money_with_symbol object.price_with_tax
  end
end
