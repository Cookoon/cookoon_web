module Pro
  class ReservationPreview < ActionMailer::Preview
    def proposed
      ReservationMailer.proposed(Reservation.last)
    end

    def accepted
      ReservationMailer.accepted(Reservation.last)
    end

    def accepted_to_host
      ReservationMailer.accepted_to_host(Reservation.last)
    end
  end
end
