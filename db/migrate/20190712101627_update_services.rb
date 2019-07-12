class UpdateServices < ActiveRecord::Migration[5.2]
  def up
    add_column :services, :name, :string
    remove_column :services, :content, :string
    remove_monetize :services, :discount_amount, currency: { present: false }
  end

  def down
    remove_column :services, :name, :string
    add_column :services, :content, :string
    add_monetize :services, :discount_amount, currency: { present: false }
  end
end
