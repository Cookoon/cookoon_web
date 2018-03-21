class ReservationsCleanupJob < ApplicationJob
  queue_as :default

  def perform
    cleanup_dropped_before_payment
    cleanup_short_notice
    cleanup_stripe_will_not_capture
  end

  private

  def cleanup_dropped_before_payment
    Reservation.dropped_before_payment.each(&:dead!)
  end

  def cleanup_short_notice
    Reservation.short_notice.each do |reservation|
      reservation.cancelled!
      # TODO : MAILER CONSEIL RESERVER PLUS TOT
    end
  end

  def cleanup_stripe_will_not_capture
    Reservation.stripe_will_not_capture.each do |reservation|
      reservation.cancelled!
      # TODO : MAILER LOCATAIRE HOTE N'A PAS REAGI
      # TODO : MAILER HOTE REMONTAGE BRETELLES
    end
  end
end
