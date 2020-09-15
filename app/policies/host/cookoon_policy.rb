class Host::CookoonPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def new?
    !user.reached_max_cookoons_count?
  end

  def create?
    !user.reached_max_cookoons_count?
  end

  def edit?
    record.user == user
  end

  def update?
    record.user == user
  end
end
