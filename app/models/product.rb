# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  description   :string(255)
#  name          :string(255)
#  minimum_units :integer
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  unit          :string(8)
#  code          :string(255)
#

class Product < ActiveRecord::Base
  attr_accessible :description, :minimum_units, :name,:code,:unit, :category_id
  belongs_to :user
  belongs_to :category
  validates :description,  :name,:unit, presence:true

  def self.import(file,user_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = where(description: row["Commodity"].upcase, name: row["Product Name"].upcase).first
      unless product
        product = Product.new
        product.description = row["Commodity"].upcase
        product.name = row["Product Name"].upcase
        product.unit = row["Unit (KG/Pieces)"]
        product.user_id= user_id
        product.code = ""
        product.save!
      end

      commodity = Category.where(name: row["Commodity"].upcase).first
      unless commodity
        commodity = Category.new
        commodity.name = row["Commodity"].upcase
        commodity.main_code = row["Main Commodity Code"]
        commodity.sub_code = row["Sub Commodity Code"]
        commodity.user_id = user_id
        commodity.save!
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.path)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
