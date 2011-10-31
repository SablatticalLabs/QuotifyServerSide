class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :quote_text
      t.datetime :quote_time
      t.string :speaker_user_id
      t.string :quotifier_user_id
      t.timestamps
    end
  end
end
