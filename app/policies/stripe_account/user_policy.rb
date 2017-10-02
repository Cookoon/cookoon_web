class StripeAccount::UserPolicy < ApplicationPolicy
  def create?
    record == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
