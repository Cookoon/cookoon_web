class ReservationGuest < ApplicationRecord
  belongs_to :reservation
  belongs_to :guest

  validates :guest, uniqueness: { scope: :reservation }

  after_create_commit :notify_guest

  private

  def notify_guest
    ReservationMailer.invitation_to_guest(reservation, guest).deliver_later
  end
end
