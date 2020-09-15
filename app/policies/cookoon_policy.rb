class CookoonPolicy < ApplicationPolicy
  def show
    record.approved?
  end

  class Scope < Scope
    def resolve
      scope.approved.displayable_on_index
    end
  end
end
