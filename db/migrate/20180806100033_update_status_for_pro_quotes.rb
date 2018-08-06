class UpdateStatusForProQuotes < ActiveRecord::Migration[5.2]
  def change
    change_column :pro_quotes, :status, :integer, null: false
  end
end
