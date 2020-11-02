class CreateMotivations < ActiveRecord::Migration[5.2]
  def change
    create_table :motivations do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
