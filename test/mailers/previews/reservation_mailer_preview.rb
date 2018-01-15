class ReservationMailerPreview < ActionMailer::Preview
  # ==== Mails for Users =====
  def new_request
    ReservationMailer.new_request(Reservation.last)
  end

  def cancelled_request
    ReservationMailer.cancelled_request(Reservation.last)
  end

  def confirmed_by_host
    ReservationMailer.confirmed_by_host(Reservation.last)
  end

  def refused_by_host
    ReservationMailer.refused_by_host(Reservation.last)
  end

  def cancelled_by_host
    ReservationMailer.cancelled_by_host(Reservation.last)
  end

  def cancelled_by_host
    ReservationMailer.cancelled_by_host(Reservation.last)
  end

  def ending_survey_for_user
    ReservationMailer.ending_survey_for_user(Reservation.last)
  end
  # ============================

  # ==== Mails for Host =====
  def pending_request
    ReservationMailer.pending_request(Reservation.last)
  end

  def cancelled_by_tenant
    ReservationMailer.cancelled_by_tenant(Reservation.last)
  end

  def confirmation
    ReservationMailer.confirmation(Reservation.last)
  end

  def cancelled_reservation
    ReservationMailer.cancelled_reservation(Reservation.last)
  end

  def cancelled_reservation
    ReservationMailer.cancelled_reservation(Reservation.last)
  end

  def ending_survey_for_host
    ReservationMailer.ending_survey_for_host(Reservation.last)
  end
  # ============================

  # ==== Notifications =====
  def notify_tenant_before_reservation
    ReservationMailer.notify_tenant_before_reservation(Reservation.last)
  end
  # ============================
end
