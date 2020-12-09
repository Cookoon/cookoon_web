class Reservation
  class Configurator
    def call
      return if skip_configuration?
      case type_name
      when 'breakfast'
        reservation.duration = 3
        reservation.start_at = start_at.change(hour: 8, min: 30)
        services.build(category: :breakfast, payment_tied_to_reservation: true)
      when 'brunch'
        reservation.duration = 4
        reservation.start_at = start_at.change(hour: 12, min: 30)
      when 'lunch'
        reservation.duration = 5
        reservation.start_at = start_at.change(hour: 12, min: 30)
      when 'lunch_cocktail'
        reservation.duration = 5
        reservation.start_at = start_at.change(hour: 12, min: 30)
      when 'diner'
        reservation.duration = 7
        reservation.start_at = start_at.change(hour: 20, min: 0)
      when 'diner_cocktail'
        reservation.duration = 7
        reservation.start_at = start_at.change(hour: 19, min: 30)
      when 'morning'
        reservation.duration = 5
        reservation.start_at = start_at.change(hour: 9, min: 0)
      when 'afternoon'
        reservation.duration = 6
        reservation.start_at = start_at.change(hour: 14, min: 0)
      when 'day'
        reservation.duration = 11
        reservation.start_at = start_at.change(hour: 9, min: 0)
      when 'amex_lunch'
        reservation.duration = 4
        reservation.start_at = start_at.change(hour: 12, min: 30)
      when 'amex_diner'
        reservation.duration = 6
        reservation.start_at = start_at.change(hour: 20, min: 0)
      end
    end

    private

    attr_reader :reservation
    delegate_missing_to :reservation

    def initialize(reservation)
      @reservation = reservation
    end

    def skip_configuration?
      quotation_proposed? || type_name.blank? || start_at.blank?
    end
  end
end
