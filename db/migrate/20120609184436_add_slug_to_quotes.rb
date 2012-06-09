class AddSlugToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :slug, :string
  end
end
