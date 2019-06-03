module ReservationStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :initial, initial: true
      state :cookoon_selected
      state :services_selected
      state :charged
      state :quotation_asked
      state :quotation_proposed
      state :accepted
      state :refused
      # state :cancelled # will probably be needed later
      state :ongoing
      state :passed
      state :dead

      event :select_cookoon do
        transitions from: [:initial, :cookoon_selected, :services_selected], to: :cookoon_selected, after: :set_cookoon, guard: :cookoon_exists?
      end

      event :select_services do
        transitions from: [:cookoon_selected, :services_selected], to: :services_selected, guard: :at_least_one_service?
      end

      event :charge do
        transitions from: :services_selected, to: :charged
      end

      event :ask_quote do
        transitions from: :services_selected, to: :quotation_asked
      end

      event :propose_quote do
        transitions from: :quotation_asked, to: :quotation_proposed
      end

      event :accept do
        transitions from: [:charged, :quotation_proposed], to: :accepted
      end

      event :refuse do
        transitions from: :charged, to: :refused
      end

      event :start do
        transitions from: :accepted, to: :ongoing
      end

      event :close do 
        transitions from: :ongoing, to: :passed
      end

      event :kill do 
        transitions from: [:initial, :quotation_asked, :quotation_proposed, :refused], to: :dead
      end
    end
  end

  def cookoon_exists?(cookoon)
    cookoon.present?
  end

  def set_cookoon(cookoon)
    self.cookoon = cookoon
  end

  def at_least_one_service?
    true
    #services.count.positive? A implementer dans la vrai version
  end
end