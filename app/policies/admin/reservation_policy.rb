class Admin::ReservationPolicy < ApplicationPolicy
  def show?
    user.admin == true
  end

  def quotation_is_sent?
    user.admin == true && record.quotation_accepted_by_host?
  end

  def quotation_is_accepted?
    user.admin == true && record.quotation_proposed?
  end

  def quotation_is_refused?
    user.admin == true && record.quotation_proposed?
  end

  def validate_menu?
    user.admin == true && record.needs_menu_validation?
  end

  def ask_menu_payment?
    user.admin == true && record.needs_menu_payment_asking?
  end

  def validate_services?
    user.admin == true && record.needs_services_validation? && record.has_all_services_validated?
  end

  def ask_services_payment?
    user.admin == true && record.needs_services_payment_asking?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
