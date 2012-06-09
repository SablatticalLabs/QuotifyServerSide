class ChangeQuoteImageIdToString < ActiveRecord::Migration
  def up
    change_column :quote_images, :id, :string
  end

  def down
    change_column :quote_images, :id, :integer
  end
end
