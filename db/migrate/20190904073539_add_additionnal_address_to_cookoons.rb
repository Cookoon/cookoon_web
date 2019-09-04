class AddAdditionnalAddressToCookoons < ActiveRecord::Migration[5.2]
  def change
    add_column :cookoons, :additionnal_address, :string
  end
end
