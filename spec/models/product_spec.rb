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

require 'spec_helper'

describe Product do
  pending "add some examples to (or delete) #{__FILE__}"
end
