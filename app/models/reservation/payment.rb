class Reservation::Payment
  include StripeChargeable

  attr_reader :reservation, :options
  delegate :user, :charge_amount_cents, :cookoon, to: :reservation
  delegate :stripe_customer, to: :user
  alias_attribute :chargeable, :reservation

  def initialize(reservation, options)
    @reservation = reservation
    @options = options
  end

  def should_capture?
    false
  end
end
