class ChangeDetailsToCategeries < ActiveRecord::Migration
  def change
    rename_column :categories, :code, :main_code
  end
end
