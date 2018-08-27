module Pro
  class ReservationPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.includes(:quote).where(pro_quotes: { company_id: user.company })
      end
    end
  end
end
