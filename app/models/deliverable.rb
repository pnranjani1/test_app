# == Schema Information
#
# Table name: deliverables
#
#  id           :integer          not null, primary key
#  product_id   :integer
#  micropost_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  quantity     :decimal(8, 2)
#  del_price    :decimal(8, 2)
#  unit_price   :decimal(8, 2)
#

class Deliverable < ActiveRecord::Base
  attr_accessible :quantity, :product_id ,:unit_price
  before_create :record_del_price

  private
  def record_del_price
    self.del_price = self.quantity * self.unit_price
  end
  
  belongs_to :micropost
  #validates :micropost_id,presence: true
  #validates :quantity, presence:true
  #validates :unit_price,presence:true
  #validates :product_id,presence:true
end
