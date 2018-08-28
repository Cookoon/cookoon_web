module Pro
  class Reservation < ApplicationRecord
    include DatesOverlapScope
    include EndAtSetter

    belongs_to :quote, class_name: 'Pro::Quote', foreign_key: :pro_quote_id, inverse_of: :reservations
    belongs_to :cookoon

    has_many :services,
             class_name: 'Pro::Service', inverse_of: :reservation,
             foreign_key: :pro_reservation_id, dependent: :destroy

    monetize :cookoon_price_cents
    monetize :services_price_cents
    monetize :fee_cents
    monetize :price_cents

    enum status: %i[draft proposed modification_requested accepted cancelled ongoing passed dead]

    delegate :company, to: :quote

    scope :engaged, -> {where(status: %i[proposed modification_requested accepted])}

    validates :start_at, presence: true
    validates :duration, numericality: { only_integer: true, greater_than: 0 }
    validates :people_count, numericality: { only_integer: true, greater_than: 0 }

    before_save :assign_prices
    after_save :update_quote_status, if: :saved_change_to_status

    private

    def assign_prices
      assign_attributes(
        cookoon_price: duration * cookoon.price,
        services_price_cents: services.sum(:price_cents),
        fee: (cookoon_price + services_price) * 0.07,
        price: cookoon_price + services_price + fee
      )
    end

    def update_quote_status
      quote.confirmed! if accepted?
    end
  end
end
