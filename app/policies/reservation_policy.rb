class ReservationPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def create?
    #can be updated to check if user has a credit card
    true
  end

  def update?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.for_tenant(user).displayable
    end
  end
end
