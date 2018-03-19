class ReservationsCleanupJob < ApplicationJob
  queue_as :default

  def perform(_scheduled_time)
    without_mail = Reservation.pending.to_cancel
    with_mail = Reservation.paid.to_cancel
    without_mail.or(with_mail).each(&:cancelled!)
    # Send mail only when reservation was paid
    # with_mail.each { PENDING SEND_MAIL }
  end
end
