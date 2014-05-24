require "open-uri"
class MicropostPdf < Prawn::Document
  def initialize(micropost,view)
    super()
    @micropost = micropost
    @view = view
    @user = User.find(@micropost.user_id)
    logo(@user,@micropost)
    seller(@user)
    if @micropost.unedit == false
    custom(@micropost.customer_id)
    end 
    delivera(@micropost)
    
    
    
  end
  def logo(user,micropost)
    
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = 100
      gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}?s=#{size}"+".jpg"
      move_down 50
      image open(gravatar_url)
      
      draw_text "Invoice", :at => [225,705],size: 22
     if micropost.bill_date == nil
       micropost.bill_date = Date.today
     end
      draw_text micropost.bill_date.to_formatted_s(:rfc822) ,:at => [480,705],size:12
      draw_text "#"+@micropost.invoice_number, :at => [0,705],size:12
  end
  def seller(user)
    bounding_box([110,670],:width =>200) do
    text user.name.capitalize,size: 18
    text user.address+" , "+user.city,size: 12
    text "Phone : "+user.phone,size: 12
    text "Email : "+user.email, size:12
    text "TIN #" +user.tin,size:12
    text "Bank Account # "+user.bank_acc_no, size:8
    text "IFSC Code # "+user.ifscode ,size:8
    
    end 
     
    
    
  end
  def custom(id)
    @customer = Customer.find(id)
    bounding_box([350,670],:width => 200) do
    text "Customer : "+@customer.name, size:18
    text @customer.address + @customer.city, size:12
    text "Phone : "+@customer.phone,size: 12
    if @customer.email != "" 
    text "Email : "+@customer.email, size:12
    end 
    if @customer.tin != "00000000000" 
      text "TIN #" +@customer.tin,size:12
    end
    end
  end
  def delivera(mip)
    move_down 70
    if @micropost.esugam != nil
      text "ESugam No #"+ @micropost.esugam
    end
    move_down 10 
    @del_items = mip.deliverables.find(:all)
    @info = mip.infos.first
    @total = 0
    @taxis = Tax.find(@info.tax_id)
    @tax = 0
    @sur_tax = 0
    @grand_total = 0 
    @count = 1
    data = [["Sl. No","Product name","Quantity","Unit Price","amount"]]
    @del_items.each do |item|
      
      @product = Product.find(item.product_id)
      
      holder = [@count,@product.name,item.quantity.to_s+" "+@product.unit,item.unit_price,item.del_price]
      data += [holder] 
      
      @total += item.del_price
      @count +=1 
      
    end
    table(data, :header => true )do
    column(1).width = 325
    end
    move_down 10 
    indent (200) do
    text "Gross Value : "+ @total.to_s ,  size:16,:align => :right
    if @info.sur_name != ""
      
       @sur_tax = @total * @info.sur_tax * 0
       move_down 10
       text @info.sur_name + " : "+ @info.sur_tax.to_s  , size:16,:align => :right
       move_down 10
       text "Value after " + @info.sur_name + " : " + (@info.sur_tax+@total).to_s, size:16,:align => :right
    else
      @info.sur_tax =0
    end 
    @taxable = @info.sur_tax+@total
    @tax = @taxable * @taxis.rate * 0.01
    move_down 10
    text @taxis.state + " @ "+ @taxis.rate.to_s + "% : " + @tax.round(2).to_s , size:16,:align => :right
    @grand_total = (@tax+@taxable).round(2)
    move_down 10
    text "Net Value : "+ @grand_total.to_s ,size:18,:align => :right
    move_down 10
    end
    text @info.gen_info, size:12 
    
    move_down 10
    text "a. Our responsibility ceases as soon as goods are handed over to the carriers.", size:12
    move_down 10
    text "b.  This sale is subject to Bangalore jurisdiction ", size:12 
    move_down 10
    text "c. Customers are liable for all losses relating to uncleared goods  ",size:12
    move_down 10
    text "d. If consignment arrives at destination in doubtful/damaged condition, take 'Open Delivery' and make written claim with the carriers
",size:12
    move_down 20
    
    indent (300) do
    text "for "+@micropost.user.name,size: 12
    move_down 40
    text "Authorized Signatory",size: 12
   
    
    end
    move_down 40
    indent (100) do
     text "This bill was created on VatOnWheels",size: 14
    end
    
    
  end

    
    
end