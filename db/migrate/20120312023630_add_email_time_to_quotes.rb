class AddEmailTimeToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :email_send_scheduled_time, :datetime
    add_column :quotes, :email_sent_flag, :boolean
  end
end
