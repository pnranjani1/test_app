# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tin        :string(255)
#  phone      :string(255)
#  address    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string(255)
#  city       :string(255)
#

class Customer < ActiveRecord::Base
  attr_accessible :address, :name, :phone, :tin ,:email , :posts_attributes,:city
  belongs_to :user
  has_many :microposts, :through => :user
  accepts_nested_attributes_for :microposts
  
  validates :user_id, presence: true
  VALID_NAME_REGEX = /^[a-zA-Z\s]*$/
  validates :city, presence: true,format: {with:VALID_NAME_REGEX}
  validates :name,presence: true
  validates :tin,presence:true,length: { is: 11}
 
  validates :phone,presence:true

  def self.import(file,user_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      customer = where(tin: row["TIN"].to_i).first
      unless customer
        customer = Customer.new
        customer.name = row["Name"].to_s
        customer.tin = row["TIN"].to_i
        customer.phone = row["Phone"].to_i
        customer.address = row["Address"]
        customer.city = row["City"]
        customer.email = row["Email"]
        customer.user_id = user_id
        customer.save!
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
