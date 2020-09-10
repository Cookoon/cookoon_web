class ChefPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # scope.has_active_menus
      scope.all
    end
  end
end
