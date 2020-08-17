class ChefPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.has_active_menus
    end
  end
end
