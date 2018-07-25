class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.integer :siren
      t.bigint :siret
      t.string :vat

      t.timestamps
    end
  end
end
