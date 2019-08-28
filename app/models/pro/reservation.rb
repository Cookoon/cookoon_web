module Pro
  class Reservation < ApplicationRecord
    include DatesOverlapScope
    include EndAtSetter
    
    scope :engaged, -> { where(status: %i[proposed modification_requested accepted]) }

    belongs_to :quote, class_name: 'Pro::Quote', foreign_key: :pro_quote_id, inverse_of: :reservations
    belongs_to :cookoon

    has_many :services,
             class_name: 'Pro::Service', inverse_of: :reservation,
             foreign_key: :pro_reservation_id, dependent: :destroy

    enum status: {
      draft_initial: 0,
      draft: 1,
      proposed_initial: 10,
      proposed: 11,
      modification_requested: 20,
      modification_processed: 21,
      accepted: 50,
      ongoing: 60,
      passed: 70,
      # dead: 80,
      # cancelled_by_tenant: 90,
      # cancelled_by_host: 91
    }

    delegate :user, :company, to: :quote

    monetize :cookoon_price_cents
    monetize :cookoon_fee_cents
    monetize :cookoon_fee_tax_cents
    monetize :services_price_cents
    monetize :services_tax_cents
    monetize :services_full_price_cents
    monetize :total_price_cents
    monetize :total_tax_cents
    monetize :total_full_price_cents

    monetize :host_payout_price_cents

    DEFAULTS = {
      fee_rate: 0.07,
      tax_rate: 0.2
    }.freeze

    validates :start_at, presence: true
    validates :duration, numericality: { only_integer: true, greater_than: 0 }
    validates :people_count, numericality: { only_integer: true, greater_than: 0 }

    before_save :assign_prices, if: :assign_prices_needed?
    after_save :update_quote_status, if: :saved_change_to_status
    after_save :report_to_slack, if: :saved_change_to_status?

    def self.fee_percentage
      DEFAULTS[:fee_rate] * 100
    end

    ### PROCEDURE DE CHARGE STRIPE
    # reservation = Pro::Reservation.find(:id)
    # source = reservation.user.company.retrieve_stripe_sources('source').data.first.id
    # reservation.payment({source: source}).proceed

    def self.tax_percentage
      DEFAULTS[:tax_rate] * 100
    end

    def admin_close
      payment.transfer
      ::ReservationMailer.notify_payout_to_host(self).deliver_later

      passed!
    end

    def payment(options = {})
      Pro::Reservation::Payment.new(self, options)
    end

    def host_fee_rate
      DEFAULTS[:fee_rate]
    end

    def host_fee_cents
      (cookoon_price_cents * host_fee_rate).round
    end

    def host_payout_price_cents
      cookoon_price_cents - host_fee_cents
    end

    def quote_reference
      "DEV-C4B-#{quote.created_at.strftime('%y%m')}#{format '%03d', quote.id}"
    end

    def invoice_reference
      "FAC-C4B-#{start_at.strftime('%y%m')}#{format '%03d', id}"
    end

    def quotation?
      status_before_type_cast < Pro::Reservation.statuses[:ongoing]
    end

    def invoice?
      status_before_type_cast >= Pro::Reservation.statuses[:ongoing]
    end

    private

    def assign_prices_needed?
      draft_initial? || draft?
    end

    def assign_prices
      assign_attributes(computed_price_attributes)
    end

    def update_quote_status
      quote.confirmed! if accepted?
    end

    def report_to_slack
      return unless Rails.env.production?
      case status
      when 'modification_requested'
        PingSlackReservationModificationRequestJob.perform_later(id)
      when 'accepted'
        PingSlackReservationAcceptJob.perform_later(id)
      end
    end

    def ical_params
      {
        host: {
          summary: "Location de votre Cookoon : #{cookoon.name}",
          description: <<~DESCRIPTION
            Location de votre Cookoon : #{cookoon.name}
          DESCRIPTION
        },
        tenant: {
          summary: "Réservation Cookoon : #{cookoon.name}",
          description: <<~DESCRIPTION
            Réservation Cookoon : #{cookoon.name}
          DESCRIPTION
        }
      }
    end
  end
end
