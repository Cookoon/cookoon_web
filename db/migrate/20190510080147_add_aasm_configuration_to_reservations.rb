class AddAasmConfigurationToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :aasm_state, :string
    add_column :reservations, :paid, :boolean, default: false
    add_column :reservations, :category, :integer, default: 0
  end
end
