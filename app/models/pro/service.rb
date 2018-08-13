module Pro
  class Service < ApplicationRecord
    belongs_to :reservation, class_name: 'Pro::Reservation', foreign_key: :pro_reservation_id, inverse_of: :services

    validates :name, presence: true
    validates :quantity, numericality: { only_integer: true, greater_than: 0 }

    monetize :unit_price_cents
    monetize :price_cents

    before_save :assign_price
    after_commit :save_reservation

    private

    def assign_price
      self.price = quantity * unit_price
    end

    def save_reservation
      reservation.save
    end
  end
end