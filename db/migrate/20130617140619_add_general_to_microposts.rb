class AddGeneralToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :gen_info, :string 
  end
end
