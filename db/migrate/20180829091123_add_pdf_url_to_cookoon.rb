class AddPdfUrlToCookoon < ActiveRecord::Migration[5.2]
  def change
    add_column :cookoons, :pdf_url, :string
  end
end
