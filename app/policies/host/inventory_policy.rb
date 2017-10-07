class Host::InventoryPolicy < ApplicationPolicy
  def create?
    true
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
