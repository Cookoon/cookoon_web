class AddCoverPictureUrlToEphemerals < ActiveRecord::Migration[5.2]
  def change
    add_column :ephemerals, :cover_picture_url, :string
  end
end
