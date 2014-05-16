class FixInfos < ActiveRecord::Migration
  def change
    
    add_column :infos,:tax, :decimal ,:precision =>8,:scale => 2
    add_column :infos, :state, :string 
    add_column :infos,:sur_tax, :decimal ,:precision =>8,:scale => 2
    add_column :infos, :category_id, :integer
    rename_column :infos,:other_information,:gen_info
    rename_column :infos,:other_charges,:sur_name
     
  end
end
