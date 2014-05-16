class AddUseridTo < ActiveRecord::Migration
  def change
    add_column :taxes, :user_id, :integer
  end
  
end
