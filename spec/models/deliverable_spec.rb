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

require 'spec_helper'

describe Deliverable do
  pending "add some examples to (or delete) #{__FILE__}"
end
