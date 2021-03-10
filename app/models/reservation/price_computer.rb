class Reservation
  module PriceComputer
    extend ActiveSupport::Concern

    MARGIN = { butler: 0.25, menu: 0.15 }.freeze
    # accessible as Reservation::MARGIN

    UNIT_PRICE_CENTS = { butler: 3500 }.freeze
    # accessible as Reservation::UNIT_PRICE_CENTS

    TAX = 0.2.freeze
    # accessible as Reservation::TAX

    def computed_price_attributes
      {
        cookoon: {
          cookoon_price: compute_cookoon_price,
        },

        butler: {
          butler_price: compute_butler_price,
          butler_tax: compute_butler_tax,
          butler_with_tax: compute_butler_with_tax,
        },

        cookoon_butler: {
          cookoon_butler_price: compute_cookoon_butler_price,
          cookoon_butler_tax: compute_cookoon_butler_tax,
          cookoon_butler_with_tax: compute_cookoon_butler_with_tax,
        },

        menu: {
          menu_price: compute_menu_price,
          menu_tax: compute_menu_tax,
          menu_with_tax: compute_menu_with_tax,
        },

        services: {
          services_price: compute_services_price,
          services_tax: compute_services_tax,
          services_with_tax: compute_services_with_tax,
        },

        total: {
          total_price: compute_total_price,
          total_tax: compute_total_tax,
          total_with_tax: compute_total_with_tax,
        }
      }
    end

    private

    def set_tax(item)
      Money.new(TAX * item)
    end

    def set_ht(item)
      Money.new(item / (1 + TAX))
    end

    # COMPUTE PRICE
    def compute_cookoon_price
      return 0 unless duration.present? && cookoon.present?

      if amex?
        cookoon_price_cents = cookoon.amex_price
      else
        cookoon_price_cents = duration * cookoon.price
      end
      # if customer? && duration > 4
      #   # discount applied
      #   cookoon_price_cents = cookoon_price_cents  * 0.85
      # end

      Money.new(cookoon_price_cents)
    end

    def compute_butler_price
      # 42€HT * butler_count * duration * MARGIN[:butler]
      return 0 unless duration.present?
      Money.new((1 + MARGIN[:butler]) * (butler_count * duration * UNIT_PRICE_CENTS[:butler]))
    end

    def compute_cookoon_butler_price
      return 0 unless duration.present?
      Money.new([compute_cookoon_price, compute_butler_price].sum)
    end

    def compute_menu_price
      if amex?
        return 0 unless menu.present?
        if menu.chef.base_price_cents.positive?
          Money.new((1 + MARGIN[:menu]) * (menu.chef.base_price_cents + (menu.unit_price_cents * people_count)))
        elsif menu.chef.min_price_cents.positive?
          Money.new((1 + MARGIN[:menu]) * ([menu.chef.min_price_cents, (menu.unit_price_cents * people_count)].max))
        end
      else
        set_ht(compute_menu_with_tax)
      end
    end

    def compute_services_price
      # return 0 unless services.present?
      Money.new(services.where.not(status: "initial").pluck(:price_cents).sum)
      # Money.new(services.pluck(:price_cents).sum)
    end

    def compute_total_price
      if amex?
        (Money.new(120000) - compute_cookoon_price) * (1 - TAX) + compute_cookoon_price
      else
        [compute_cookoon_butler_price, compute_menu_price, compute_services_price].sum
      end
    end


    # COMPUTE TAX
    def compute_butler_tax
      set_tax(compute_butler_price)
    end

    def compute_cookoon_butler_tax
      set_tax(compute_butler_price)
    end

    def compute_menu_tax
      set_tax(compute_menu_price)
    end

    def compute_services_tax
      set_tax(compute_services_price)
    end

    def compute_total_tax
      if amex?
        (Money.new(120000) - compute_cookoon_price) * TAX
      else
        [compute_cookoon_butler_tax, compute_menu_tax, compute_services_tax].sum
      end
    end


    # COMPUTE WITH TAX
    def compute_butler_with_tax
      [compute_butler_price, compute_butler_tax].sum
    end

    def compute_cookoon_butler_with_tax
      [compute_cookoon_butler_price, compute_cookoon_butler_tax].sum
    end

    def compute_menu_with_tax
      if amex?
        [compute_menu_price, compute_menu_tax].sum
      else
        return 0 unless menu.present?
        menu.price_with_tax_per_person(people_count) * people_count
        # price_with_tax_per_person available in app/models/menu/concerns/price_computer
      end
    end

    def compute_services_with_tax
      [compute_services_price, compute_services_tax].sum
    end

    def compute_total_with_tax
      if amex?
        Money.new(120000)
      else
        [compute_total_price, compute_total_tax].sum
      end
    end

  end
end

# Code Charles

#   def computed_price_attributes
#     {
#       cookoon_price: compute_cookoon_price,
#       services_price: compute_services_price,
#       services_tax: compute_services_tax,
#       services_with_tax: compute_services_with_tax,
#       total_price: compute_total_price,
#       total_tax: compute_total_tax,
#       total_with_tax: compute_total_with_tax
#     }
#   end

#   private

# def compute_services_tax
#   Money.new(compute_services_price * 0.20)
# end

# def compute_services_with_tax
#   Money.new(compute_services_price * 1.20)
# end

# def compute_total_tax
#   Money.new(compute_services_price * 0.20)
# end

# def compute_total_with_tax
#    Money.new([compute_cookoon_price, compute_services_with_tax].sum)
# end

# def compute_cookoon_price
#   return 0 unless duration.present? && cookoon.present?
#   cookoon_price_cents = duration * cookoon.price
#   if customer? && duration > 4
#     # discount applied
#     cookoon_price_cents = cookoon_price_cents  * 0.85
#   end
#   Money.new(cookoon_price_cents)
# end

# def compute_services_price
#   services_price_cents = services.pluck(:price_cents).sum
#   services_price_cents += builtin_service_price_cents
#   services_price_cents += menu_price_cents
#   Money.new(services_price_cents)
# end

# def builtin_service_price_cents
#   [production_fees_cents, butler_fees_cents].sum
# end

# def production_fees_cents
#   # gratuit pour perso
#   return 0 if customer?
#   (duration * 5000)
# end

# def butler_fees_cents
#   return 0 unless duration
#   # 46,50 euro par heure
#   # 1 butler pour 10 invités pro
#   # 1 butler pour 8 invités perso
#   (4650 * duration) * butler_count
# end

# def menu_price_cents
#   # prix unitaire du menu * nombre de personne
#   # minimun 500 euros
#   return 0 unless menu.present?
#   [(menu.unit_price_cents * people_count) , 50000].max
# end

#  def compute_total_price
#   Money.new([compute_cookoon_price, compute_services_price].sum)
# end
