module Pro
  class UserPolicy < ApplicationPolicy
    delegate :pro?, to: :user
  end
end
