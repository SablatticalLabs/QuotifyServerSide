class AddErrorToQuoteUponSend < ActiveRecord::Migration
  def change
	add_column :quotes, :error_flag, :boolean
	add_column :quotes, :error_string, :string
  end
end
