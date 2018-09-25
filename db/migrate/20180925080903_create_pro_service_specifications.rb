class CreateProServiceSpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :pro_service_specifications do |t|
      t.string :name
      t.monetize :unit_price

      t.timestamps
    end
  end
end
