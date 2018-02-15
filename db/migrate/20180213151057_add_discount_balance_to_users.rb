class AddDiscountBalanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discount_balance_cents, :integer, default: 0
    add_column :users, :discount_expires_at, :datetime
  end
end
