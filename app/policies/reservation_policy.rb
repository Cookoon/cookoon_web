class ReservationPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def new?
    true
  end

  def create?
    #can be updated to check if user has a credit card
    if record.business?
      user.pro?
    else
      true
    end
  end

  # def update?
  #   record.user == user
  # end

  def amounts?
    record.user == user
  end

  def ask_quotation?
    record.business?
  end

  def select_menu?
    record.user == user && record.needs_menu_selection?
  end

  def select_cookoon?
    record.user == user
  end

  # def reset_menu?
  #   record.user == user
  # end

  def cooking_by_user?
    record.user == user
  end

  # def reset_cooking_by_user?
  #   record.user == user
  # end

  def select_services?
    record.user == user
  end

  def secret_cookoon_butler?
    record.user == user && record.needs_cookoon_butler_payment?
  end

  def secret_menu?
    record.user == user && record.needs_menu_payment?
  end

  def secret_services?
    record.user == user && record.needs_services_payment?
  end

  def cookoon_butler_stripe_intent?
    secret_cookoon_butler?
  end

  def menu_stripe_intent?
    secret_menu?
  end

  def services_stripe_intent?
    secret_services?
  end

  class Scope < Scope
    def resolve
      scope.for_tenant(user).displayable
    end
  end
end
