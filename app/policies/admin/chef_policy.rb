class Admin::ChefPolicy < ApplicationPolicy
  def show?
    user.admin == true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
