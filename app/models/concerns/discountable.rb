module Discountable
  def discountable_discount_amount_cents
    return 0 unless discount_asked?
    @discountable_discount_amount_cents ||= compute_discount_amount_cents
  end

  def discountable_charge_amount_cents
    @discountable_charge_amount_cents ||= compute_charge_amount_cents
  end

  def discountable_discount_amount
    Money.new discountable_discount_amount_cents
  end

  def discountable_charge_amount
    Money.new discountable_charge_amount_cents
  end

  def persist_discount
    update_payable
    update_user
  end

  def discount_used?
    payable.discount_amount_cents.positive?
  end

  def refund_user_discount
    return unless discount_used?
    user.discount_balance_cents += payable.discount_amount_cents
    user.save
  end

  private

  def discount_asked?
    ActiveModel::Type::Boolean.new.cast(options[:discount])
  end

  def discount_amount_used
    ActionController::Base.helpers.humanized_money_with_symbol(payable.discount_amount)
  end

  def update_payable
    payable.update(discount_amount_cents: discountable_discount_amount_cents)
  end

  def update_user
    user.discount_balance_cents -= discountable_discount_amount_cents
    user.save
  end

  def compute_discount_amount_cents
    return 0 unless user.available_discount?
    user_discount_cents = user.discount_balance_cents
    [user_discount_cents, payment_amount_cents].min
  end

  def compute_charge_amount_cents
    payment_amount_cents - discountable_discount_amount_cents
  end
end
