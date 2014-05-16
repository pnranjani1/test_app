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

require 'spec_helper'

describe Info do
  pending "add some examples to (or delete) #{__FILE__}"
end
