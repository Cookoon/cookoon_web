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
    update_discountable
    update_user
  end

  def discount_used?
    chargeable.discount_amount_cents.positive?
  end

  def refund_user_discount
    return unless discount_used?
    user.discount_balance_cents += chargeable.discount_amount_cents
    user.save
  end

  private

  def update_discountable
    chargeable.update(discount_amount_cents: discountable_discount_amount_cents)
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
