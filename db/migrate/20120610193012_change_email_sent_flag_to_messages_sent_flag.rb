class ChangeEmailSentFlagToMessagesSentFlag < ActiveRecord::Migration
  def up
    rename_column :quotes, :email_sent_flag, :messages_sent_flag 
  end

  def down
    rename_column :quotes, :messages_sent_flag, :email_sent_flag
  end
end
