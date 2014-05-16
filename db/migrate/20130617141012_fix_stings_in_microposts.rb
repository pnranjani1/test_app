class FixStingsInMicroposts < ActiveRecord::Migration
  def change
    change_column :microposts, :gen_info, :text
    change_column :microposts, :content, :text
  end
end
