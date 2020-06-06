class Admin::ReservationPolicy < ApplicationPolicy
  def show?
    user.admin == true
  end

  def require_payment_for_menu?
    user.admin == true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
