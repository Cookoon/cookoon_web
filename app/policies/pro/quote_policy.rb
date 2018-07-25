module Pro
  class QuotePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def create?
      record.user.pro?
    end
  end
end
