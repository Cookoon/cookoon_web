class CreateAmexCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :amex_codes do |t|
      t.string :code
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
