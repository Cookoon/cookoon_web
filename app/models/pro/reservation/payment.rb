module Pro
  class Reservation
    class Payment < ::Payment
      include Stripe::Transferable
      # SepaCreditable

    end
  end
end
