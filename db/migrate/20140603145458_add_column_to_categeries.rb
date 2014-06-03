class AddColumnToCategeries < ActiveRecord::Migration
  def change
    add_column :categories, :sub_code, :string
  end
end
