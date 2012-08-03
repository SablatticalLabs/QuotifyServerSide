class AddUniqueQuoteIdsPerUser < ActiveRecord::Migration
  def change
    add_column :quotes, :quotifier_quote_id, :string
    add_column :quotes, :speaker_quote_id, :string
    add_column :quote_witness_users, :witness_quote_id, :string
  end
end
