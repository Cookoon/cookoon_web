module Pro
  class QuotePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def create?
      true
    end

    def update?
      record.user == user
    end
  end
end
