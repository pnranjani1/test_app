class AddMicropostIdToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :micropost_id, :integer
    add_column :microposts,:info_id,:integer
  end
end
