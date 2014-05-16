class AddDateToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts,:bill_date,:date
  end
end
