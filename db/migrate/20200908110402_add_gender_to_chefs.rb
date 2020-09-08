class AddGenderToChefs < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :gender, :string
  end
end
