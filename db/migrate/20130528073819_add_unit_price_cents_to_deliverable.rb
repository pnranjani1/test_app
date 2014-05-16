class AddUnitPriceCentsToDeliverable < ActiveRecord::Migration
  def change
    add_column :deliverables, :unit_price, :integer
    
  end
end
