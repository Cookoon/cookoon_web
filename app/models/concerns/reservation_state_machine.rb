module ReservationStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :initial, initial: true
      state :cookoon_selected
      state :menu_selected
      state :services_selected
      state :charged
      state :accepted
      state :services_paid
      state :quotation_asked
      state :quotation_proposed
      state :quotation_accepted
      state :refused
      state :cancelled
      state :ongoing
      state :passed
      state :dead

      event :select_cookoon do
        transitions from: [:initial, :menu_selected, :cookoon_selected, :services_selected],
          to: :cookoon_selected,
          after: [:set_cookoon, :set_prices]
      end

      event :select_menu do
        transitions from: [:cookoon_selected, :menu_selected],
          to: :menu_selected,
          after: [:set_menu, :set_prices]
      end

      event :select_services do
        transitions from: [:cookoon_selected, :services_selected],
          to: :services_selected,
          after: [:set_services, :set_prices]
      end

      event :charge do
        transitions from: :services_selected, to: :charged
      end

      event :pay_services do
        transitions from: :accepted, to: :services_paid
      end

      event :ask_quotation do
        transitions from: :services_selected, to: :quotation_asked
      end

      event :propose_quotation do
        transitions from: :quotation_asked, to: :quotation_proposed
      end

      event :accept do
        transitions from: [:charged], to: :accepted
      end

      event :accept_quotation do
        transitions from: [:quotation_proposed], to: :quotation_accepted
      end

      event :refuse do
        transitions from: :charged, to: :refused
      end

      event :cancel do
        transitions from: [:initial, :cookoon_selected, :menu_selected, :services_selected, :charged, :quotation_asked, :quotation_proposed], to: :cancelled
      end

      event :start do
        transitions from: :accepted, to: :ongoing
      end

      event :close do
        transitions from: :ongoing, to: :passed
      end

      event :kill do
        transitions from: [:initial, :cookoon_selected, :menu_selected, :services_selected, :charged, :quotation_asked, :quotation_proposed, :accepted, :refused, :ongoing, :passed, :dead], to: :dead
      end
    end
  end

  def set_cookoon(cookoon)
    self.cookoon = cookoon
  end

  def set_menu(menu)
    self.menu = menu
  end

  def set_services(service_categories)
    services.where(category: [:sommelier, :parking, :corporate, :catering, :flowers]).each(&:destroy)
    service_categories.each do |service_category|
      services.create(category: service_category, payment_tied_to_reservation: true)
    end
  end

  def set_prices
    assign_prices
  end
end
