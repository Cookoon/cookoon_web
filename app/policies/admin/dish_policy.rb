class Admin::DishPolicy < ApplicationPolicy

  def create?
    user.admin == true
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

end
