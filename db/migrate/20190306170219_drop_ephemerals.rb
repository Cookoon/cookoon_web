class DropEphemerals < ActiveRecord::Migration[5.2]
  def change
    drop_table :ephemerals
  end
end
