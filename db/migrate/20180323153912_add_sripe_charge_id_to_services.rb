class AddSripeChargeIdToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :stripe_charge_id, :string
  end
end
