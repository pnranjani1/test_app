class ChangeCurrencies < ActiveRecord::Migration
  def change
    change_table :deliverables do |t|
      t.rename :del_price_cents,:del_price
      t.change :del_price,:decimal,:precision =>8,:scale => 2
      t.change :unit_price,:decimal,:precision =>8,:scale => 2
    end
    
  end
end
