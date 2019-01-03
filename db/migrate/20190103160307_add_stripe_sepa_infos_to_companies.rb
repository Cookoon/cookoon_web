class AddStripeSepaInfosToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :stripe_bank_name, :string
    add_column :companies, :stripe_bic, :string
    add_column :companies, :stripe_iban, :string
  end
end
