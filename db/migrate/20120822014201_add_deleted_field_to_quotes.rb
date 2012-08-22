class AddDeletedFieldToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :deleted, :boolean
  end
end
