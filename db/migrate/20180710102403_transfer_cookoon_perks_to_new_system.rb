class TransferCookoonPerksToNewSystem < ActiveRecord::Migration[5.2]
  def up
    display_device = PerkSpecification.create! name: 'Écran', icon_name: 'logo'
    sound_system = PerkSpecification.create! name: 'Système son', icon_name: 'logo'
    kitchen = PerkSpecification.create! name: 'Cuisine équipée', icon_name: 'logo'
    elevator = PerkSpecification.create! name: 'Ascenseur', icon_name: 'logo'
    barbecue = PerkSpecification.create! name: 'Barbecue', icon_name: 'logo'
    fireplace = PerkSpecification.create! name: 'Cheminée', icon_name: 'logo'
    tableware = PerkSpecification.create! name: 'Vaisselle', icon_name: 'logo'

    ActiveRecord::Base.transaction do
      Cookoon.all.each do |cookoon|
        cookoon.perks.create(perk_specification: display_device) if cookoon.display_device
        cookoon.perks.create(perk_specification: sound_system) if cookoon.sound_system
        cookoon.perks.create(perk_specification: kitchen) if cookoon.kitchen
        cookoon.perks.create(perk_specification: elevator) if cookoon.elevator
        cookoon.perks.create(perk_specification: barbecue) if cookoon.barbecue
        cookoon.perks.create(perk_specification: fireplace) if cookoon.fireplace
        cookoon.perks.create(perk_specification: tableware, quantity: cookoon.tableware_quantity) unless cookoon.tableware_quantity.nil?
      end
    end

    remove_column :cookoons, :display_device
    remove_column :cookoons, :sound_system
    remove_column :cookoons, :kitchen
    remove_column :cookoons, :elevator
    remove_column :cookoons, :barbecue
    remove_column :cookoons, :fireplace
    remove_column :cookoons, :tableware_quantity
  end

  def down
    add_column :cookoons, :display_device, :boolean, default: false, null: false
    add_column :cookoons, :sound_system, :boolean, default: false, null: false
    add_column :cookoons, :kitchen, :boolean, default: false, null: false
    add_column :cookoons, :elevator, :boolean, default: false, null: false
    add_column :cookoons, :barbecue, :boolean, default: false, null: false
    add_column :cookoons, :fireplace, :boolean, default: false, null: false
    add_column :cookoons, :tableware_quantity, :integer

    ActiveRecord::Base.transaction do
      Cookoon.all.each do |cookoon|
        cookoon.perks.each do |perk|
          case perk.name
          when 'Écran' then cookoon.update(display_device: true)
          when 'Système son' then cookoon.update(sound_system: true)
          when 'Cuisine équipée' then cookoon.update(kitchen: true)
          when 'Ascenseur' then cookoon.update(elevator: true)
          when 'Barbecue' then cookoon.update(barbecue: true)
          when 'Cheminée' then cookoon.update(fireplace: true)
          when 'Vaisselle' then cookoon.update(tableware_quantity: perk.quantity)
          end
        end
      end
    end

    PerkSpecification.destroy_all
    
    drop_table :perks
    drop_table :perk_specifications
  end
end
