module Pro
  class ReservationPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
        # TODO: FC 22aug18 make this work!
        # scope.includes(:quote).where(pro_quote: { company: user.company })
      end
    end
  end
end
