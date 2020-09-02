class Admin::UserPolicy < ApplicationPolicy

  def add_identity_documents?
    user.admin == true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
