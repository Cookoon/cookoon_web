class Admin::CookoonPolicy < ApplicationPolicy
  def update?
    user.admin == true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
