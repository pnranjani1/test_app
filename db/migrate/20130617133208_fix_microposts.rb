class FixMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :unedit , :boolean, default:false
    add_column :microposts,:tax, :decimal ,:precision =>8,:scale => 2
    add_column :microposts, :state, :string 
    add_column :microposts, :invoice_number , :string
  end
end
