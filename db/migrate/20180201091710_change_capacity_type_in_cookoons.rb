class ChangeCapacityTypeInCookoons < ActiveRecord::Migration[5.1]
  def change
    change_column :cookoons, :capacity, 'integer USING CAST(capacity AS integer)'
  end
end
