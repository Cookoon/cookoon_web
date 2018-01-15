class StripeAccount::UserPolicy < ApplicationPolicy
  def create?
    record.stripe_account_id.nil? && record == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
