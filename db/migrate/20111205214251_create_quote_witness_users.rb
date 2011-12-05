class CreateQuoteWitnessUsers < ActiveRecord::Migration
  def change
		create_table :quote_witness_users, :force => true do |t|
		    t.integer :quote_id
		    t.integer :user_id
		    t.timestamps
		  end
  end

end
