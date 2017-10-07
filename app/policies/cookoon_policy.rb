class CookoonPolicy < ApplicationPolicy
  def show?
    record.user == user || record.approved?
  end

  def create?
    true
  end

  class Scope < Scope
    def resolve
      scope.includes(:photo_files).approved.displayable_on_index
    end
  end
end
