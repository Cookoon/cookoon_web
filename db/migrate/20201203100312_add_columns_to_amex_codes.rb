class AddColumnsToAmexCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :amex_codes, :email, :string
    add_column :amex_codes, :first_name, :string
    add_column :amex_codes, :last_name, :string
    add_column :amex_codes, :phone_number, :string
    add_reference :amex_codes, :reservation, foreign_key: true
  end
end
