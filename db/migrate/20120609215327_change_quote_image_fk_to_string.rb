class ChangeQuoteImageFkToString < ActiveRecord::Migration
  def up
    change_column :quote_images, :quote_id, :string
  end

  def down
    change_column :quote_images, :quote_id, :integer
  end
end
