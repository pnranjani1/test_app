# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  code       :string(255)
#  user_id    :integer
#

class Category < ActiveRecord::Base
  attr_accessible :name,:main_code, :sub_code
  belongs_to :user
  has_many :microposts, :through => :user
  has_many :products
  validates :user_id, presence: true
  validates :name,:main_code , presence: true
end
