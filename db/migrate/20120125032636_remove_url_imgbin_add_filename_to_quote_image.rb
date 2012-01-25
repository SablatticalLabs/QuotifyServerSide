class RemoveUrlImgbinAddFilenameToQuoteImage < ActiveRecord::Migration
  def change
    remove_column :quote_images, :image_binary
    remove_column :quote_images, :url
    add_column :quote_images, :file_name, :string
  end

end
