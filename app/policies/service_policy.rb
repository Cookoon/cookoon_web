class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    record.reservation.user == user
  end

  def destroy?
    create?
  end
end
