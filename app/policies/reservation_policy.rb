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

  def update?
    record.user == user
  end

  def amounts?
    record.user == user
  end

  def ask_quotation?
    record.business?
  end

  def select_menu?
    true
  end

  def reset_menu?
    true
  end

  def select_services?
    true
  end

  class Scope < Scope
    def resolve
      scope.for_tenant(user).displayable
    end
  end
end
