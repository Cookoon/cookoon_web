class Reservation::GuestPolicy < ApplicationPolicy
  def create?
    true
  end

  class Scope < Scope
    def resolve
      scope.last
    end
  end
end
