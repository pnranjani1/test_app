class FixColumnName < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.rename :price_cents, :tax
      
      
    end
  end

 
end
