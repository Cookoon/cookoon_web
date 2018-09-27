module Pro
  class UserPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def update?
      record == user
    end
  end
end
