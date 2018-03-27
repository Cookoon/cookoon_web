class Reservation::Payment
  include Chargeable

  attr_reader :chargeable, :options
  delegate :user, :charge_amount_cents, :cookoon, to: :chargeable

  def initialize(reservation, options)
    @chargeable = reservation
    @options = options
  end

  def should_capture?
    false
  end

end
