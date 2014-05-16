class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :other_charges
      t.text :other_information
      

      t.timestamps
    end
  end
end
