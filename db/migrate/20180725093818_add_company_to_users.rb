class AddCompanyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :company, foreign_key: true
  end
end
