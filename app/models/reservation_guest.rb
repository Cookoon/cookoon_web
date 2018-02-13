class ReservationGuest < ApplicationRecord
  belongs_to :reservation
  belongs_to :guest

  accepts_nested_attributes_for :guest, reject_if: :all_blank

  validates :guest, uniqueness: { scope: :reservation }
end
