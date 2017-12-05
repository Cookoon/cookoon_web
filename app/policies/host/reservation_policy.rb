class Host::ReservationPolicy < ApplicationPolicy
  def create?
    record.cookoon.user == user
  end

  def update?
    record.cookoon.user == user
  end

  class Scope < Scope
    def resolve
      # here scope is an array because of namespacing
      scope.last.for_host(user).displayable
    end
  end
end
