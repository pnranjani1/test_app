class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :description
      t.string :name
      t.integer :minimum_units
      t.integer :user_id

      t.timestamps
    end
  end
end
