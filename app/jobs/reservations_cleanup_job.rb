class ReservationsCleanupJob < ApplicationJob
  queue_as :default

  def perform
    cleanup_dropped_before_payment
    cleanup_short_notice
    # cleanup_stripe_will_not_capture
    cleanup_host_did_not_reply_in_validity_period
  end

  private

  def cleanup_dropped_before_payment
    Reservation.dropped_before_payment.each(&:kill!)
  end

  def cleanup_short_notice
    Reservation.short_notice.each do |reservation|
      reservation.cancel!
      # ReservationMailer.autocancel_short_notice_to_tenant(reservation).deliver_later
    end
  end

  # def cleanup_stripe_will_not_capture
  #   Reservation.stripe_will_not_capture.each do |reservation|
  #     reservation.cancel!
  #     # ReservationMailer.autocancel_stripe_period_to_tenant(reservation).deliver_later
  #     # ReservationMailer.autocancel_stripe_period_to_host(reservation).deliver_later
  #   end
  # end

  def cleanup_host_did_not_reply_in_validity_period
    Reservation.host_did_not_reply_in_validity_period.each do |reservation|
      reservation.cancel_because_host_did_not_reply_in_validity_period!
    end
  end
end
