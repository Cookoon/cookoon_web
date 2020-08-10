class AddCitationToChefs < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :citation, :string
  end
end
