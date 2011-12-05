class AddLocationAndCoordsToQuote < ActiveRecord::Migration
  def change
		add_column :quotes, :location, :string
		add_column :quotes, :coordinate, :string
  end
end
