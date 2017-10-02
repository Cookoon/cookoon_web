class CookoonPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    true
  end

  class Scope < Scope
    def resolve
      scope.displayable_on_index
    end
  end
end
