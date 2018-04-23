class SearchPolicy < ApplicationPolicy
  def create?
    true
  end

  def update_all?
    true
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
