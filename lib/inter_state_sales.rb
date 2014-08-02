class InterStateSales
  attr_accessor :xml
  def initialize(user_id)
    @xml = ""
    @user = User.where(id: user_id).first
    @microposts = @user.microposts.where("MONTH(created_at) = ?",Date.today.strftime("%m"))
  end

  def generate_xml



   xml = "<ISSale>"
    xml += "<Version>13.11</Version>"
    xml += "<TinNo>#{@user.tin}</TinNo>"
    xml += "<RetPerdEnd>2014</RetPerdEnd>"
    xml += "<FilingType>M</FilingType>"
    xml += "<Period>#{Date.today.strftime("%m").to_i}</Period>"
   @microposts.each do |micropost|
     infos = micropost.infos.first
     taxis = Tax.find(infos.tax_id)

     if taxis.state == 'CST'
       net_value = micropost.deliverables.map{|x| x.del_price.to_i}.inject(:+)
       taxable = infos.sur_tax + net_value

       tax = taxable * taxis.rate * 0.01
       grand_total = (tax+taxable).round(2)

       p_id = micropost.deliverables.first.product_id rescue nil
       category_id = Product.where(id: p_id).first.category_id unless p_id.blank?
       main_com = Category.where(id: category_id).first.main_code rescue nil

       xml += "<ISSalesInv>"
       xml += "<PurTin>#{micropost.customer.tin}</PurTin>"
       xml += "<PurName>#{micropost.customer.name}</PurName>"
       xml += "<PurAddr>#{micropost.customer.address}</PurAddr>"
       xml += "<InvNo>#{micropost.invoice_number}</InvNo>"
       xml += "<InvDate>#{micropost.bill_date.to_s}</InvDate>"
       xml += "<NetVal>#{net_value}</NetVal>"
       xml += "<TaxCh>#{tax}</TaxCh>"
       xml += "<OthCh>#{micropost.sur_tax}</OthCh>"
       xml += "<TotCh>#{grand_total}</TotCh>"
       xml += "<TranType>#{taxis.rate.to_s == '2' ? 'C' : 'WC'}</TranType>"
       xml += "<MainComm>#{main_com}</MainComm>"
       xml += "<SubComm>1</SubComm>"
       xml += "<Qty>#{micropost.deliverables.map{|x| x.quantity}.inject(:+)}</Qty>"
       xml += "</ISSalesInv>"
     end
   end
   xml += "</ISSale>"
   xml
  end
end