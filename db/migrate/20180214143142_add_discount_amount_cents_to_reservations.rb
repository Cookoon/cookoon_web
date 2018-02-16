class AddDiscountAmountCentsToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :discount_amount_cents, :integer, default: 0, null: false
  end
end
