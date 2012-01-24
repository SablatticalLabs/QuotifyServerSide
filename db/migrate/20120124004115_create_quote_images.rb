class CreateQuoteImages < ActiveRecord::Migration
  def change
    create_table :quote_images do |t|
      t.references :quote
      t.string :name
      t.string :url
      t.binary :image_binary
      t.timestamps
    end
  end
end
