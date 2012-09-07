class AddComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.column :comment_text, :string, :null => false
      t.column :quote_id, :string
      t.column :email_sent_flag, :boolean
      t.column :commenter_name, :string
      t.timestamps
     end
  end

 end
