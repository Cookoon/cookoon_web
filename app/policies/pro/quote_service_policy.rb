module Pro
  class QuoteServicePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def create?
      record.quote.user == user
    end

    def destroy?
      create?
    end
  end
end
