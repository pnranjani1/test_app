class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :tin
      t.string :phone
      t.string :address
      t.integer :user_id

      t.timestamps
    end
  end
end
