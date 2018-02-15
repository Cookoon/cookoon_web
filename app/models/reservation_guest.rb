class ReservationGuest < ApplicationRecord
  belongs_to :reservation
  belongs_to :guest

  validates :guest, uniqueness: { scope: :reservation }

  after_create :notify_guest

  private

  def notify_guest
    ReservationMailer.invited_by_tenant(reservation, guest).deliver_later
  end
end
