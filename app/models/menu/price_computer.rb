class Menu
  module PriceComputer
    extend ActiveSupport::Concern

    def price_with_tax_per_person(people_count)
      Money.new((price_with_tax_per_person_without_rounding(people_count) / 5).ceil(-2) * 5)
    end

    private

    def price_with_tax_per_person_without_rounding(people_count)
      if chef.base_price_cents.positive?
        ((1 + Reservation::TAX) * (1 + Reservation::MARGIN[:menu]) * (chef.base_price_cents + unit_price_cents * people_count)) / people_count
      elsif chef.min_price_cents.positive?
        ((1 + Reservation::TAX) * (1 + Reservation::MARGIN[:menu]) * [chef.min_price_cents, unit_price_cents * people_count].max) / people_count
      end
    end
  end
end
