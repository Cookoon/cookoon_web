class Admin::ServicePolicy < ApplicationPolicy
  def new?
    user.admin == true && record.reservation.accepts_new_service?
  end

  def create?
    new?
  end

  def edit?
    user.admin == true && record.reservation.needs_services_validation?
  end

  def update?
    edit?
  end

  # class Scope < Scope
  #   def resolve
  #     scope.all
  #   end
  # end
end
