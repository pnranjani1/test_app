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

class Micropost < ActiveRecord::Base
  attr_accessible :content , :customer ,:customer_id,:category_id,:tax,:invoice_number,:state,:sur_name,:sur_tax,:gen_info,:bill_date,:esugam,:unedit

  attr_accessible :deliverables_attributes, :infos_attributes


  
  
  belongs_to :user
  belongs_to :customer
  belongs_to :category
  validates :invoice_number,presence:true
  has_many :deliverables, dependent: :destroy
  has_many :infos,dependent: :destroy
  validates :customer_id,presence:true
  validates :user_id, presence: true

  accepts_nested_attributes_for :deliverables,:infos,:allow_destroy => true
  
  default_scope order: 'microposts.created_at DESC'
  
 def self.to_csv(options = {})
   CSV.generate(options) do |csv|
     csv << ["Date","Particulars","Voucher type","Vch No." ,"TIN/Sales Tax No."," Customer Name","Total","Other Charges","Tax Type","Tax rate","Tax Amount", "Gross Total"]
     all.each do |bill|
       if bill.deliverables.any? && bill.infos.any? 
         total = totaller(bill)
         help = Product.find(bill.deliverables.first.product_id).name
         info = bill.infos.first
         taxis = Tax.find(info.tax_id)
         if bill.unedit == false
           cut_in = bill.customer.tin
           cut_na = bill.customer.name
         else
           cut_in = "Not applicable"
           cut_na = "Cash Transaction"
         end 
         if info.sur_name == ""
           sur_tax =0 
         else
           if info.sur_tax != nil
           sur_tax= info.sur_tax
           else
             sur_tax = 0
           end
         end
        tamount = ((total + sur_tax) * taxis.rate * 0.01).round(2)
           csv << [bill.bill_date,help,"Sales",bill.invoice_number,cut_in,cut_na,total,sur_tax,taxis.state,taxis.rate,tamount,(tamount+total+sur_tax) ]
           
       
       end 
         
     end
   end
 end
 def self.totaller(bill)
   total =0 
   bill.deliverables.each do |deli|
     total += deli.del_price
   
     end
   return total  
 end
 def self.quantifier(bill)
   deli = bill.deliverables[0]
   item = Product.find(deli.product_id)
   prod = deli.quantity.to_s + " " + item.unit
   return prod
 end
 
  
end
