module Pro
  class ServiceDecorator < Draper::Decorator
    delegate_all

    def unit_price
      h.humanized_money_with_symbol object.unit_price
    end

    def price
      h.humanized_money_with_symbol object.price
    end
  end
end
