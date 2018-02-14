class ReservationGuest < ApplicationRecord
  belongs_to :reservation
  belongs_to :guest

  validates :guest, uniqueness: { scope: :reservation }
end
