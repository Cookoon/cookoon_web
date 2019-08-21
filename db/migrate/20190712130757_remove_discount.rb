class RemoveDiscount < ActiveRecord::Migration[5.2]
  def change
    remove_column :reservations, :discount_amount_cents, :integer
    remove_column :users, :discount_balance_cents, :integer
    remove_column :users, :discount_expires_at, :datetime
  end
end
