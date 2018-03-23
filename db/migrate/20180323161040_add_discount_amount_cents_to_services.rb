class AddDiscountAmountCentsToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :discount_amount_cents, :integer, default: 0
  end
end
