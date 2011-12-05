class ModifyUserAttributesToMatchIphone < ActiveRecord::Migration
  def change
		rename_column :users, :email_address, :email
		rename_column :users, :phone_number, :phone
  end

end
