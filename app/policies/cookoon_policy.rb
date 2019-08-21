class CookoonPolicy < ApplicationPolicy
  def show?
    record.user == user || record.approved?
  end

  def create?
    true
  end

  def update?
    record.user == user
  end

  def select_cookoon?
    record.approved?
  end

  class Scope < Scope
    def resolve
      scope.approved.displayable_on_index
    end
  end
end
