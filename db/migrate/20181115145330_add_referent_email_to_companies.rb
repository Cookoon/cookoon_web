class AddReferentEmailToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :referent_email, :string
  end
end
