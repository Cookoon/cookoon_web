class AddSpecialOfferToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :special_offer, :string
  end
end
