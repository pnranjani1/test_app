class FixInfosCategory < ActiveRecord::Migration
  def change
    rename_column :infos,:category_id,:tax_id
  end
end
