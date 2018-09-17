module Host
  class ReservationPolicy < ApplicationPolicy
    def create?
      record.cookoon.user == user
    end

    def update?
      record.cookoon.user == user
    end

    class Scope < Scope
      def resolve
        scope.for_host(user).displayable
      end
    end
  end
end
