class FixProduct < ActiveRecord::Migration
  def change
    rename_column :products, :tax ,:unit
    change_column :products, :unit, :string
  end
end
