class Host::UserPolicy < ApplicationPolicy
  def dashboard?
    record == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
