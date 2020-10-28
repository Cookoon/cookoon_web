class AddMembershipAskingToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :membership_asking, :boolean
  end
end
