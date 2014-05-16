# == Schema Information
#
# Table name: microposts
#
#  id             :integer          not null, primary key
#  content        :text(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  customer_id    :integer
#  category_id    :integer
#  unedit         :boolean          default(FALSE)
#  tax            :decimal(8, 2)
#  state          :string(255)
#  invoice_number :string(255)
#  sur_tax        :decimal(8, 2)
#  sur_name       :string(255)
#  gen_info       :text(255)
#  bill_date      :date
#  esugam         :string(255)
#  info_id        :integer
#

require 'spec_helper'

describe Micropost do
  let(:user) {FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  
  subject { @micropost }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user}
  
  it { should be_valid }
  
  
  describe "accessible attributes" do
    it "should not allow access to user_id " do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  describe "when user_id is not present" do
    before { @micropost.user_id = nil}
    it { should_not be_valid}
  end
  describe "with blank content" do
    before { @micropost.content = " "}
    it { should_not be_valid}
  end
  describe "with extra length  content" do
    before { @micropost.content = "a"*141 }
    it { should_not be_valid}
  end
end
