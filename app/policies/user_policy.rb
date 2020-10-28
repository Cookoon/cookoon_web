class UserPolicy < ApplicationPolicy

  def update?
    user == record
  end

  def impersonate?
    user_can_access?
  end

  def stop_impersonating?
    user_can_access?
  end

  def edit_general_conditions_acceptance?
    update?
  end

  def update_general_conditions_acceptance?
    update?
  end

  private

  def user_can_access?
    # we need to perform check on record because of pretender gem
    record.admin?
  end

  class Scope < Scope
    def resolve
      scope.where.not(admin: true)
    end
  end
end
