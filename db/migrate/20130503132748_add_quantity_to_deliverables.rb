class AddQuantityToDeliverables < ActiveRecord::Migration
  def change
    add_column :deliverables, :quantity, :integer
    add_column :deliverables, :del_price_cents, :integer
  end
end
