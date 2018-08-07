module Pro
  class Reservation < ApplicationRecord
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

    enum status: %i[draft proposed accepted cancelled ongoing passed dead]

    validates :start_at, presence: true
    validates :duration, numericality: { only_integer: true, greater_than: 0 }
    validates :people_count, numericality: { only_integer: true, greater_than: 0 }
  end
end
