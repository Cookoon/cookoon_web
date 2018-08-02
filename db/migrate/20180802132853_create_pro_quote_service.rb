class CreateProQuoteService < ActiveRecord::Migration[5.2]
  def change
    create_table :pro_quote_services do |t|
      t.references :pro_quote, foreign_key: true
      t.integer :category, default: 0, null: false
      t.string :name
      t.integer :quantity
    end
  end
end
