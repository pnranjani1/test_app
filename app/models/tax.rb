# == Schema Information
#
# Table name: taxes
#
#  id      :integer          not null, primary key
#  state   :string(255)
#  rate    :decimal(, )
#  user_id :integer
#

class Tax < ActiveRecord::Base
  attr_accessible :state,:rate
  belongs_to :user
  validates :state,:rate ,:user_id, presence: true
end
