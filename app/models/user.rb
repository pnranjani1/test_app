# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#  esugam_id       :string(255)
#  esugam_pwd      :string(255)
#  tin             :string(255)
#  address         :string(255)
#  phone           :string(255)
#  bank_acc_no     :string(255)
#  ifscode         :string(255)
#  city            :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :esugam_id, :esugam_pwd , :tin, :address, :phone ,:bank_acc_no, :ifscode,:city
  has_secure_password
  has_many :taxes,dependent: :destroy,:class_name => "Tax"
  has_many :microposts, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :categories, dependent: :destroy 
  has_many :products, dependent: :destroy
  
  before_save { |user| user.email = email.downcase}
  before_save :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  validates :esugam_id,:esugam_pwd,:address,:phone,:bank_acc_no,presence:true
  validates :tin ,presence: true, length: { is: 11}
  VALID_NAME_REGEX = /^[a-zA-Z\s]*$/
  validates :city, presence: true,format: {with:VALID_NAME_REGEX}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with:VALID_EMAIL_REGEX } ,uniqueness: { case_sensitive: false}
  validates :password, presence: true, length: { minimum: 6}
  validates :password_confirmation, presence: true 
   def feed
    Micropost.where("user_id = ?", id)
  end
  def cat_feed
    Category.where("user_id = ?", id)
  end
  def tax_feed
    Tax.where("user_id = ?", id)
  end
  
  private 
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
 
  
end
