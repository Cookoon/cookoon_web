class RemoveOrderFromChefPerks < ActiveRecord::Migration[5.2]
  def change
    remove_column :chef_perks, :order, :integer
  end
end
