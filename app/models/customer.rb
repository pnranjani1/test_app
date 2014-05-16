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
end
