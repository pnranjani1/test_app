class AddSurchargeToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts,:sur_tax, :decimal ,:precision =>8,:scale => 2
    add_column :microposts, :sur_name, :string 
  end
end
