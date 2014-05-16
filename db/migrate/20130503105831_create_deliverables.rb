class CreateDeliverables < ActiveRecord::Migration
  def change
    create_table :deliverables do |t|
      t.integer :product_id
      t.integer :micropost_id

      t.timestamps
    end
  end
end
