class AddStripeInscriptionIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_inscription_id, :string
  end
end
