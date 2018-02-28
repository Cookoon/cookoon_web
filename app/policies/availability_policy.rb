class AvailabilityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user_owns_cookoon?
  end

  def update?
    user_owns_cookoon?
  end

  private

  def user_owns_cookoon?
    record.cookoon.user == user
  end
end
