class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email_address
      t.string :phone_number
      t.string :contact_method
      t.timestamps
    end
  end
end
