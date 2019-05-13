class AddTypeNameToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :type_name, :string
  end
end
