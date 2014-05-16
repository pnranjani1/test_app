class Tax < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :state
      t.decimal :rate
      

    end 
   end 
end
