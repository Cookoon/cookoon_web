class User
  class Payment < ::Payment
    alias_method :user, :payable

    INSCRIPTION_PRICE_CENTS = 45000.freeze
    INSCRIPTION_PRICE = (INSCRIPTION_PRICE_CENTS / 100).freeze

    def capture_inscription_payment
      if errors.empty?
        user.update(inscription_payment_required: false)
      end
    end

    private

    def intent_description
      "Paiement pour l'inscription de #{user.first_name} #{user.last_name} (#{user.email})"
    end

    def intent_metadata
      {
        user_id: user.id,
        inscription_price: options[:charge_amount_cents],
      }
    end
  end
end
