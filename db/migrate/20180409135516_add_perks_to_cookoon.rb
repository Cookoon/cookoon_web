class AddPerksToCookoon < ActiveRecord::Migration[5.1]
  def change
    add_column :cookoons, :digicode, :string
    add_column :cookoons, :building_number, :string
    add_column :cookoons, :floor_number, :string
    add_column :cookoons, :door_number, :string
    add_column :cookoons, :wifi_network, :string
    add_column :cookoons, :wifi_code, :string
    add_column :cookoons, :display_device, :boolean, default: false, null: false
    add_column :cookoons, :sound_system, :boolean, default: false, null: false
    add_column :cookoons, :kitchen, :boolean, default: false, null: false
    add_column :cookoons, :elevator, :boolean, default: false, null: false
    add_column :cookoons, :barbecue, :boolean, default: false, null: false
    add_column :cookoons, :fireplace, :boolean, default: false, null: false
    add_column :cookoons, :caretaker_instructions, :text
  end
end
