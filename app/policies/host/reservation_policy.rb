class Host::ReservationPolicy < ApplicationPolicy
  def update?
    record.cookoon.user == user
  end

  class Scope < Scope
    def resolve
      # here scope is an array because of namespacing
      scope.last.includes(:user, :cookoon).where(status: [:paid, :refused, :passed, :ongoing, :accepted]).where(cookoon: user.cookoons)
    end
  end
end
