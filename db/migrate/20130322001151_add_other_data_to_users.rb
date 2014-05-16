class AddOtherDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :esugam_id, :string
    add_column :users, :esugam_pwd, :string
    add_column :users, :tin, :string
    add_column :users, :address, :string
    add_column :users, :phone, :string
    
    add_column :users, :bank_acc_no, :string
    add_column :users, :ifscode, :string
  end
end
