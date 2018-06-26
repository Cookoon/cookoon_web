class AddBornOnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :born_on, :date
  end
end
