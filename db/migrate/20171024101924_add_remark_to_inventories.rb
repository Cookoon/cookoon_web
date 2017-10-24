class AddRemarkToInventories < ActiveRecord::Migration[5.1]
  def change
    add_column :inventories, :remark, :text
  end
end
