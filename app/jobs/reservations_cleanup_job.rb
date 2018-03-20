class ReservationsCleanupJob < ApplicationJob
  queue_as :default

  def perform
    cleanup_pending_unpayable
    cleanup_short_notice
    cleanup_stripe_will_not_capture
  end

  private

  def cleanup_pending_unpayable
    Reservation.pending_unpayable.each(&:dead!)
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
      # TODO : MAILER HOTE N'A PAS REAGI
    end
  end
end
