class AddAmexToCookoons < ActiveRecord::Migration[5.2]
  def change
    add_column :cookoons, :amex, :boolean, default: false
  end
end
