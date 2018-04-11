class AddAdditionnalPerksToCookoon < ActiveRecord::Migration[5.1]
  def change
    add_column :cookoons, :basic_cooking_ingredients, :boolean, default: false, null: false
    add_column :cookoons, :crockery_quantity, :integer
  end
end
