class ReservationGuestPolicy < ApplicationPolicy
  def create?
    record.reservation.user == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
