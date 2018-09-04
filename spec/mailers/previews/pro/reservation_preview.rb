module Pro
  class ReservationPreview < ActionMailer::Preview
    def proposed
      ReservationMailer.proposed(Reservation.last)
    end
  end
end
