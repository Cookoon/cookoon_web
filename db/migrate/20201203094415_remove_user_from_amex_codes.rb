class RemoveUserFromAmexCodes < ActiveRecord::Migration[5.2]
  def change
    remove_reference :amex_codes, :user, foreign_key: true
  end
end
