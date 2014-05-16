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
  attr_accessible :description, :minimum_units, :name,:code,:unit
  belongs_to :user
  validates :description,  :name,:unit, presence:true
end
