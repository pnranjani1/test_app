class AddCodeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :code, :string
    change_column :products, :tax , :decimal , :precision =>8,:scale => 2
  end
end
