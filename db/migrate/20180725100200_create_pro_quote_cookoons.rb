class CreateProQuoteCookoons < ActiveRecord::Migration[5.2]
  def change
    create_table :pro_quote_cookoons do |t|
      t.references :pro_quote, foreign_key: true
      t.references :cookoon, foreign_key: true

      t.timestamps
    end
  end
end
