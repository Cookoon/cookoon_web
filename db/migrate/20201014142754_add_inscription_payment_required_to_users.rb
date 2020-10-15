class AddInscriptionPaymentRequiredToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :inscription_payment_required, :boolean
  end
end
