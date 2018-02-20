class CreateGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :guests do |t|
      t.references :user, foreign_key: true
      t.string :email
      t.string :first_name
      t.string :last_name
    end
  end
end
