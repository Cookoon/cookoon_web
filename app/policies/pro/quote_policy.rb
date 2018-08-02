module Pro
  class QuotePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def create?
      user.pro?
    end

    def update?
      record.user == user
    end
  end
end
