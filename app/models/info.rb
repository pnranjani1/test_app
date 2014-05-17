# == Schema Information
#
# Table name: infos
#
#  id           :integer          not null, primary key
#  sur_name     :string(255)
#  gen_info     :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax          :decimal(8, 2)
#  state        :string(255)
#  sur_tax      :decimal(8, 2)
#  tax_id       :integer
#  micropost_id :integer
#

class Info < ActiveRecord::Base
  attr_accessible :sur_tax,:sur_name,:tax_id,:gen_info
  belongs_to :micropost
  validates :tax_id,presence:true
end
