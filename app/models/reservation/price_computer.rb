class Reservation
  module PriceComputer
    extend ActiveSupport::Concern

    def computed_price_attributes
      {
        cookoon_price: compute_cookoon_price,
        services_price: compute_services_price,
        services_tax: compute_services_tax,
        services_with_tax: compute_services_with_tax,
        total_price: compute_total_price,
        total_tax: compute_total_tax,
        total_with_tax: compute_total_with_tax
      }
    end

    private

    def compute_services_tax
      Money.new(compute_services_price * 0.20)
    end

    def compute_services_with_tax
      Money.new(compute_services_price * 1.20)
    end

    def compute_total_tax
      Money.new(compute_services_price * 0.20)
    end

    def compute_total_with_tax
       Money.new([compute_cookoon_price, compute_services_with_tax].sum)
    end

    def compute_cookoon_price
      return 0 unless duration.present? && cookoon.present?
      cookoon_price_cents = duration * cookoon.price
      if customer? && duration > 4
        # discount applied
        cookoon_price_cents = cookoon_price_cents  * 0.85
      end
      Money.new(cookoon_price_cents)
    end

    def compute_services_price
      services_price_cents = services.pluck(:price_cents).sum
      services_price_cents += builtin_service_price_cents
      services_price_cents += menu_price_cents
      Money.new(services_price_cents)
    end

    def builtin_service_price_cents
      [production_fees_cents, butler_fees_cents].sum
    end

    def production_fees_cents
      # gratuit pour perso 
      return 0 if customer?
      (duration * 5000)
    end

    def butler_fees_cents
      return 0 unless duration
      # 46,50 euro par heure
      # 1 butler pour 10 invités pro
      # 1 butler pour 8 invités perso
      (4650 * duration) * butler_count
    end

    def menu_price_cents
      # prix unitaire du menu * nombre de personne
      # minimun 500 euros
      return 0 unless menu.present?
      [(menu.unit_price_cents * people_count) , 50000].max
    end

     def compute_total_price
      Money.new([compute_cookoon_price, compute_services_price].sum)
    end
  end
end
