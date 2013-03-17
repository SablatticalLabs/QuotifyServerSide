class AddModeToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :mode, :string
  end
end
