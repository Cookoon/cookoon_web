class Admin::ReservationPolicy < ApplicationPolicy
  def show?
    user.admin == true
  end

  def validate_menu?
    user.admin == true && record.needs_menu_validation?
  end

  def ask_menu_payment?
    user.admin == true && record.needs_menu_payment_asking?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
