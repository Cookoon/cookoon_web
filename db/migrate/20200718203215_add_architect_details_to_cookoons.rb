class AddArchitectDetailsToCookoons < ActiveRecord::Migration[5.2]
  def change
    add_column :cookoons, :architect_build_year, :integer
    add_column :cookoons, :architect_title, :string
    add_column :cookoons, :architect_url, :string
  end
end
