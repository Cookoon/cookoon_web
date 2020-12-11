class AddTermsOfServiceToAmexCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :amex_codes, :terms_of_service, :boolean, default: false
  end
end
