class AddCustomerIdToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :customer_id, :integer
  end
end
