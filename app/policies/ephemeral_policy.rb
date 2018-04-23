class EphemeralPolicy < ApplicationPolicy
  def show?
    true
  end

  def pay?
    true
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
