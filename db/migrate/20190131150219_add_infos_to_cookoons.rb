class AddInfosToCookoons < ActiveRecord::Migration[5.2]
  def change
    add_column :cookoons, :address_complement, :string
    add_column :cookoons, :capacity_standing, :integer
    add_column :cookoons, :recommended_uses, :text
    add_column :cookoons, :perks_complement, :text
    add_column :cookoons, :architect_name, :string
  end
end
