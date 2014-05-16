class AddEsugamToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts,:esugam,:string
  end
end
