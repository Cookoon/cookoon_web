class AddPictureUrlToChef < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :picture_url, :string
  end
end
