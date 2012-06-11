class ChangeEmailSendScheduledTimeToMessages < ActiveRecord::Migration
  def up
    rename_column :quotes, :email_send_scheduled_time, :messages_send_scheduled_time
  end

  def down
    rename_column :quotes, :messages_send_scheduled_time, :email_send_scheduled_time
  end
end
