class Admin::MenuPolicy < ApplicationPolicy

  def show?
    user.admin == true
  end

  def new?
    create?
  end

  def create?
    user.admin == true
  end

  def edit?
    update?
  end

  def update?
    user.admin == true
  end

  def validate_menu?
    user.admin == true
  end

  def archive_menu?
    user.admin == true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

end
