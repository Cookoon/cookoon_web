class ReservationMailerPreview < ActionMailer::Preview
  # ==== Mails for Users =====
  # def paid_request_to_tenant
  #   ReservationMailer.paid_request_to_tenant(Reservation.last)
  # end

  def quotation_host_confirmation_to_host
    ReservationMailer.quotation_host_confirmation_to_host(Reservation.business.last)
  end

  def amex_host_confirmation_to_tenant
    ReservationMailer.amex_host_confirmation_to_tenant(Reservation.amex.engaged.last)
  end

  def amex_host_confirmation_to_host
    ReservationMailer.amex_host_confirmation_to_host(Reservation.amex.engaged.last)
  end

  def amex_request_to_tenant
    ReservationMailer.amex_request_to_tenant(Reservation.amex.engaged.last)
  end

  def amex_request_to_host
    ReservationMailer.amex_request_to_host(Reservation.amex.engaged.last)
  end

  def paid_request_cookoon_butler_to_tenant
    ReservationMailer.paid_request_cookoon_butler_to_tenant(Reservation.customer.last)
  end

  def paid_request_cookoon_butler_to_tenant
    ReservationMailer.paid_request_cookoon_butler_to_tenant(Reservation.customer.last)
  end

  def paid_request_menu_to_tenant
    ReservationMailer.paid_request_menu_to_tenant(Reservation.customer.last)
  end

  def paid_confirmation_menu_to_tenant
    ReservationMailer.paid_confirmation_menu_to_tenant(Reservation.customer.last)
  end

  def paid_request_services_to_tenant
    ReservationMailer.paid_request_services_to_tenant(Reservation.customer.last)
  end

  def paid_confirmation_services_to_tenant
    ReservationMailer.paid_confirmation_services_to_tenant(Reservation.customer.last)
  end

  def quotation_request_to_tenant
    ReservationMailer.quotation_request_to_tenant(Reservation.business.last)
  end

  def quotation_request_to_host
    ReservationMailer.quotation_request_to_host(Reservation.business.last)
  end

  # def cancelled_by_tenant_to_tenant
  #   ReservationMailer.cancelled_by_tenant_to_tenant(Reservation.last)
  # end

  # def refused_to_tenant
  #   ReservationMailer.refused_to_tenant(Reservation.last)
  # end

  # def cancelled_by_host_to_tenant
  #   ReservationMailer.cancelled_by_host_to_tenant(Reservation.last)
  # end

  # def ending_survey_to_tenant
  #   ReservationMailer.ending_survey_to_tenant(Reservation.last)
  # end

  # ==== Mails for Host =====
  # def paid_request_to_host
  #   ReservationMailer.paid_request_to_host(Reservation.last)
  # end

  def paid_request_cookoon_butler_to_host
    ReservationMailer.paid_request_cookoon_butler_to_host(Reservation.customer.last)
  end

  def paid_confirmation_cookoon_butler_to_host
    ReservationMailer.paid_confirmation_cookoon_butler_to_host(Reservation.customer.last)
  end

  # def notify_awaiting_request_to_host
  #   ReservationMailer.notify_awaiting_request_to_host(Reservation.last)
  # end

  # def cancelled_by_tenant_to_host
  #   ReservationMailer.cancelled_by_tenant_to_host(Reservation.last)
  # end

  # def cancelled_by_host_to_host
  #   ReservationMailer.cancelled_by_host_to_host(Reservation.last)
  # end

  # def ending_survey_to_host
  #   ReservationMailer.ending_survey_to_host(Reservation.last)
  # end

  # def notify_payout_to_host
  #   ReservationMailer.notify_payout_to_host(Reservation.last)
  # end
  # ============================

  # ==== Notifications =====
  # def notify_approaching_reservation_to_tenant
  #   ReservationMailer.notify_approaching_reservation_to_tenant(Reservation.last)
  # end

  # def notify_approaching_reservation_to_host
  #   ReservationMailer.notify_approaching_reservation_to_host(Reservation.last)
  # end

  # def autocancel_stripe_period_to_host
  #   ReservationMailer.autocancel_stripe_period_to_host(Reservation.last)
  # end

  # def autocancel_stripe_period_to_tenant
  #   ReservationMailer.autocancel_stripe_period_to_tenant(Reservation.last)
  # end

  # def autocancel_short_notice_to_tenant
  #   ReservationMailer.autocancel_short_notice_to_tenant(Reservation.last)
  # end
  # ============================
end
