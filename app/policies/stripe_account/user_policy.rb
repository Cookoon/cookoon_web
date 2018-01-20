class StripeAccount::UserPolicy < ApplicationPolicy
  def new?
    record.stripe_account_id.nil?
  end

  def create?
    record == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
