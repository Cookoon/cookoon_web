class Admin::UserPolicy < ApplicationPolicy

  def add_identity_documents?
    user.admin == true
  end

  def send_invitation?
    user.admin == true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
