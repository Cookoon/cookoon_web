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
      state :menu_payment_captured
      state :services_payment_captured
      state :quotation_asked
      state :quotation_accepted_by_host
      state :quotation_refused_by_host
      state :quotation_proposed
      state :quotation_accepted
      state :quotation_refused
      state :refused
      # state :cancelled
      state :cancelled_because_host_did_not_reply_in_validity_period
      state :ongoing
      state :passed
      state :dead

      event :select_cookoon do
        transitions from: [:initial, :menu_selected, :cookoon_selected, :services_selected],
          to: :cookoon_selected,
          after: [:set_cookoon, :set_prices]
      end

      event :select_menu do
        transitions from: [:initial, :menu_selected, :cookoon_selected, :services_selected],
        # transitions from: [:cookoon_selected, :menu_selected],
          to: :menu_selected,
          after: [:set_menu, :set_prices]
      end

      event :select_services do
        transitions from: [:initial, :menu_selected, :cookoon_selected, :services_selected],
        # transitions from: [:cookoon_selected, :services_selected],
          to: :services_selected,
          after: [:set_services, :set_prices]
      end

      event :charge do
        # transitions from: :services_selected, to: :charged
        transitions from: [:menu_selected, :cookoon_selected, :services_selected],
        # transitions from: [:cookoon_selected, :services_selected],
          to: :charged
      end

      event :capture_menu_payment do
        transitions from: :accepted, to: :menu_payment_captured
      end

      event :capture_services_payment do
        transitions from: [:accepted, :menu_payment_captured], to: :services_payment_captured
      end

      event :ask_quotation do
        transitions from: [:menu_selected, :cookoon_selected, :services_selected], to: :quotation_asked
      end

      event :host_accept_quotation do
        transitions from: :quotation_asked, to: :quotation_accepted_by_host
      end

      event :host_refuse_quotation do
        transitions from: :quotation_asked, to: :quotation_refused_by_host
      end

      event :send_quotation do
        transitions from: :quotation_accepted_by_host, to: :quotation_proposed
      end

      event :accept_quotation do
        transitions from: :quotation_proposed, to: :quotation_accepted
      end

      event :refuse_quotation do
        transitions from: :quotation_proposed, to: :quotation_refused
      end

      event :accept do
        transitions from: [:charged], to: :accepted
      end

      event :refuse do
        transitions from: :charged, to: :refused
      end

      # event :cancel do
      #   transitions from: [:initial, :cookoon_selected, :menu_selected, :services_selected, :charged, :quotation_asked, :quotation_proposed], to: :cancelled
      # end

      event :cancel_because_host_did_not_reply_in_validity_period do
        transitions from: [:charged, :quotation_asked], to: :cancelled_because_host_did_not_reply_in_validity_period
      end

      event :start do
        transitions from: :accepted, to: :ongoing
      end

      event :close do
        transitions from: :ongoing, to: :passed
      end

      event :kill do
        transitions from: [:initial, :cookoon_selected, :menu_selected, :services_selected], to: :dead
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
    services.where(category: [:sommelier, :parking, :corporate, :catering, :flowers, :wine]).each(&:destroy)
    service_categories.each do |service_category|
      services.create(category: service_category, payment_tied_to_reservation: true)
    end
  end

  def set_prices
    assign_prices
    # assign_prices_for_cookoon_butler_menu
  end
end
