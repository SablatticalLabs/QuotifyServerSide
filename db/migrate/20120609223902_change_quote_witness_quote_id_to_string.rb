class ChangeQuoteWitnessQuoteIdToString < ActiveRecord::Migration
  def up
    change_column :quote_witness_users, :quote_id, :string 
  end

  def down
    change_column :quote_witness_users, :quote_id, :integer
  end
end
