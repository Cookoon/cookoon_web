class AddCitationToCookoons < ActiveRecord::Migration[5.2]
  def change
    add_column :cookoons, :citation, :string
  end
end
