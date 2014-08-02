class LocalSales
  attr_accessor :xml
  def initialize(user_id,month)
    @xml = ""
    @user = User.where(id: user_id).first
    d = date = Date.new(Date.today.year,month.to_i,1)
    @microposts = @user.microposts.where("created_at >= ? and created_at <= ?",d.at_beginning_of_month,d.at_end_of_month)
  end

  def generate_xml

    xml = "<SaleDetails>"
    xml += "<Version>13.11</Version>"
    xml += "<TinNo>#{@user.tin}</TinNo>"
    xml += "<RetPerdEnd>2014</RetPerdEnd>"
    xml += "<FilingType>M</FilingType>"
    xml += "<Period>#{Date.today.strftime("%m").to_i}</Period>"
    @microposts.each do |micropost|
      infos = micropost.infos.first
      taxis = Tax.find(infos.tax_id)

      if taxis.state == 'VAT'
        net_value = micropost.deliverables.map{|x| x.del_price.to_i}.inject(:+)
        taxable = infos.sur_tax + net_value
        tax = taxable * taxis.rate * 0.01
        grand_total = (tax+taxable).round(2)


        xml += "<SaleInvoiceDetails>"
        xml += "<PurTin>#{micropost.customer.tin}</PurTin>"
        xml += "<PurName>#{micropost.customer.name}</PurName>"
        xml += "<InvNo>#{micropost.invoice_number}</InvNo>"
        xml += "<InvDate>#{micropost.bill_date.to_s}</InvDate>"
        xml += "<NetVal>#{net_value}</NetVal>"
        xml += "<TaxCh>#{tax}</TaxCh>"
        xml += "<OthCh>#{micropost.sur_tax}</OthCh>"
        xml += "<TotCh>#{grand_total}</TotCh>"
        xml += "</SaleInvoiceDetails>"
      end
    end
    xml += "</SaleDetails>"
    xml
  end
end