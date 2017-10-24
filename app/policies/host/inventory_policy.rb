class Host::InventoryPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    true
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
