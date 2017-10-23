class ReservationPolicy < ApplicationPolicy
  def create?
    #can be updated to check if user has a credit card
    true
  end

  class Scope < Scope
    def resolve
      scope.where.not(status: :pending).includes(cookoon: :photo_files).where(user: user)
    end
  end
end
