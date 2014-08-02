require 'local_sales'
require 'inter_state_sales'
class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :show]
  before_filter :correct_user, only: [ :destroy , :show]

  def create
=begin
    if params[:micropost][:bill_date] == nil
      params[:micropost][:bill_date] = Date.today
    end
=end

    @micropost = current_user.microposts.build
    params[:micropost][:customer]= Customer.find(params[:micropost][:customer])



    if Rails.cache.read("mp_id")!=nil
      update
    else
      if @micropost.update_attributes(params[:micropost])
        if @micropost.bill_date == nil
          @micropost.update_column(:bill_date,Date.today)
        end
        @customer = Customer.find(@micropost.customer_id)
        if  @customer.name == "Cash"
          @micropost.update_column(:unedit, true)
        else
          @micropost.update_column(:unedit, false)
        end

        @bill = @micropost
        Rails.cache.write("mp_id",@micropost.id)
        flash[:success] = "Micropost created ! with customer id" + @micropost.customer.id.to_s()
        redirect_to micropost_path(Rails.cache.read('mp_id')) and return
        respond_to do |format|
          format.html {redirect_to root_url}
          format.js
        end

      else
        @feed_items = []
        respond_to do |format|
          format.html {redirect_to root_url}
          format.js {render :js => "alert("+@micropost.errors.full_messages.to_s+");"}
        end

      end
    end




  end
  def destroy
    @micropost.destroy
    redirect_to root_url


  end

  def local_sales
    month = params['Month'][0..1]
    xml = LocalSales.new(current_user.id,month).generate_xml
    send_data xml,
              :filename =>  "Local_sales_"+Date.today.strftime("%m")+".xml",
              :type => "text/xml; charset=UTF-8",
              :disposition => "attachment"
    end

  def interstate_sales
    month = params['Month'][0..1]
    xml = InterStateSales.new(current_user.id,month).generate_xml
    send_data xml,
              :filename =>  "Interstate_sales_"+Date.today.strftime("%m")+".xml",
              :type => "text/xml; charset=UTF-8",
              :disposition => "attachment"
  end


  def show

    @bill = @micropost
    @del_items = @micropost.deliverables.find(:all)
    @info = @micropost.infos.first
    @customer = @micropost.customer
    @user = current_user
    respond_to do |format|
      format.html  do
        if params[:cause] == "esn"

          esugano=esnget(@micropost)
          if esugano != nil && esugano.length < 15
            @micropost.update_attribute('esugam',esugano)
          end
        end

      end
      format.pdf do
        pdf = MicropostPdf.new(@micropost,view_context)
        send_data pdf.render, filename:"micropost_#{@micropost.created_at.strftime("%d/%m/%y")}.pdf",
                  type: "application/pdf" ,disposition: "inline"
      end
      format.xml do
        xmldat = xml_make(@micropost)
        send_data xmldat,:filename =>  "bill"+@micropost.invoice_number.to_s+".xml",:type => "text/xml; charset=UTF-8",:disposition => "attachment"

      end




    end






  end
  def download(info)


  end
  def index
    @feed_items = current_user.feed.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.csv { send_data @feed_items.to_csv }
      format.xls { send_data @feed_items.to_csv(col_sep: "\t")}
      format.xml do
        xml_dat = " "


        if @feed_items.any?

          @feed_items.each do |biller|
            if biller.bill_date != nil && biller.deliverables.first != nil && biller.infos.first != nil  && biller.bill_date > params[:start_date].to_date && biller.bill_date <= params[:end_date].to_date
              xml_dat += $/ + xml_make(biller)
            end
          end

        end
        xml_dat = xml_dat.gsub("
</REQUESTDATA>
</IMPORTDATA>
</BODY>
</ENVELOPE>
<ENVELOPE>
<HEADER>
<TALLYREQUEST>Import Data</TALLYREQUEST>
</HEADER>
<BODY>
<IMPORTDATA>
<REQUESTDESC>
<REPORTNAME>Vouchers</REPORTNAME>
<STATICVARIABLES>
<SVCURRENTCOMPANY>nikhil shivpuja</SVCURRENTCOMPANY>
</STATICVARIABLES>
</REQUESTDESC> 
<REQUESTDATA> 
","\n")
        send_data xml_dat,:filename =>  "bill"+params[:start_date]+params[:end_date]+".xml",:type => "text/xml; charset=UTF-8",:disposition => "attachment"


      end
    end
  end
  def update
    @micropost = current_user.microposts.find(Rails.cache.read("mp_id"))
    if @micropost.update_attributes(params[:micropost])
      @customer = Customer.find(@micropost.customer_id)
      if  @customer.name == "Cash"
        @micropost.update_column(:unedit, true)
      else
        @micropost.update_column(:unedit, false)
      end

      @bill = @micropost
      respond_to do |format|
        format.html {redirect_to root_url}
        format.js
      end
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  def pdf
    @example_text = "some text"
    render :pdf => "file_name",
           :template => 'microposts/show.pdf.erb',
           :layout => 'pdf'

  end
  def xml_make(micropost)
    @micropost = micropost
    @deliverables = @micropost.deliverables

    @info = @micropost.infos.first

    @del = @deliverables[0]
    @product = Product.find(@del.product_id)
    @stringer =" " + @del.quantity.to_s + " "+ @product.unit
    @tax = Tax.find(@info.tax_id)
    @total = 0

    @deliverables.each do |deliverable|
      @total += deliverable.del_price
    end

    @totis = @total
    if @info.sur_name != "" && @info.sur_tax != nil
      @total += @info.sur_tax
    end
    @totax = @total +(@total * @tax.rate*0.01)
    @totax = @totax.round(2)
    fill_o = '<ALLLEDGERENTRIES.LIST>'+$/+'<REMOVEZEROENTRIES>No</REMOVEZEROENTRIES>'+$/+'<ISDEEMEDPOSITIVE>No</ISDEEMEDPOSITIVE>'+$/
    fill_c = '</ALLLEDGERENTRIES.LIST>'+$/
    xml_string = '<ENVELOPE>'+$/+'<HEADER>'+$/+'<TALLYREQUEST>Import Data</TALLYREQUEST>'+$/+'</HEADER>'+$/+'<BODY>'+$/+'<IMPORTDATA>'+$/+'<REQUESTDESC>'+$/+'<REPORTNAME>Vouchers</REPORTNAME>'+$/+'<STATICVARIABLES>'+$/
    xml_string+= '<SVCURRENTCOMPANY>'+micropost.user.name+'</SVCURRENTCOMPANY>'+$/+'</STATICVARIABLES>'+$/+'</REQUESTDESC> '+$/+'<REQUESTDATA> '+$/+'<TALLYMESSAGE xmlns:UDF="TallyUDF">'+$/+'<VOUCHER REMOTEID="aaeb8870-afa4-4fe9-bd6f-0f75021f37b5-3RAJ115952" VCHTYPE="Sales" ACTION="Create">'+$/+"<VOUCHERTYPENAME>Sales</VOUCHERTYPENAME>"
    xml_string+= $/+'<DATE>'+micropost.bill_date.to_s(:db).delete('-') + '</DATE>'+$/+'<EFFECTIVEDATE>'+micropost.bill_date.to_s(:db).delete('-') + '</EFFECTIVEDATE>'+$/+'<REFERENCE>'+ micropost.invoice_number + '</REFERENCE>'+$/+'<NARRATION></NARRATION>'+$/+'<GUID>aaeb8870-afa4-4fe9-bd6f-0f75021f37b5-3RAJ115952</GUID>'+$/
    xml_string += '<ALLLEDGERENTRIES.LIST>'+$/+'<REMOVEZEROENTRIES>No</REMOVEZEROENTRIES>'+$/+'<ISDEEMEDPOSITIVE>Yes</ISDEEMEDPOSITIVE>'+$/+'<LEDGERNAME>'+micropost.customer.name+'</LEDGERNAME>'+$/+'<AMOUNT>'+'-'+@totax.to_s+'</AMOUNT>'+$/
    xml_string += fill_c  + fill_o + '<LEDGERNAME>' + @tax.rate.to_s + "% Sale"+'</LEDGERNAME>' +$/+'<AMOUNT>' + @totis.to_s + '</AMOUNT>' + $/ +fill_c
    if @info.sur_name != "" && @info.sur_tax != nil
      xml_string += fill_o + '<LEDGERNAME>' +@info.sur_name + '</LEDGERNAME>' +$/+ '<AMOUNT>'+ @info.sur_tax.to_s+'</AMOUNT>'+fill_c
    end
    xml_string += fill_o + '<LEDGERNAME>' + @tax.state.capitalize  + " @ " + @tax.rate.to_s + '%</LEDGERNAME>' +$/ + '<AMOUNT>' +(@total * @tax.rate*0.01).to_s + '</AMOUNT>'+$/ +fill_c
    xml_string += '</VOUCHER>'+$/+'</TALLYMESSAGE>'+$/+'</REQUESTDATA>'+$/+'</IMPORTDATA>'+$/+'</BODY>'+$/+'</ENVELOPE>'





  end
  def esnget(micropost)
    @micropost = micropost
    @deliverables = @micropost.deliverables
    @info = @micropost.infos.first
    @sur = 0
    @del = @deliverables[0]
    @product = Product.find(@del.product_id)
    @stringer =" " + @del.quantity.to_s + " "+ @product.unit
    @tax = Tax.find(@info.tax_id)
    @total = 0
    @deliverables.each do |deliverable|
      @total += deliverable.del_price
    end
    if @info.sur_name != "" && @info.sur_tax != nil
      @total += @info.sur_tax
    end
    @taxer = @total * @tax.rate*0.01
    @taxer = @taxer.round(2)
    @totax = @total +(@total * @tax.rate*0.01)
    @totax = @totax.round(2)
    begin
      browser = Watir::Browser.new

      browser.goto  "http://vat.kar.nic.in/"
      url = nil
      browser.windows.last.use do
        url = browser.url
      end
      browser.goto url
      browser.button(:value,"Continue").click rescue nil
      browser.button(:value,"Conitnue").click rescue nil
      browser.text_field(:id, "UserName").set(@micropost.user.esugam_id)
      browser.text_field(:id, "Password").set(@micropost.user.esugam_pwd)
      browser.button(:value,"Login").click
      browser.button(:value,"Continue").click rescue nil
      browser.goto "#{url}/CheckInvoiceEnabled.aspx?Form=ESUGAM1"
      if @tax.state == "CST"
        browser.radio(:id, "ctl00_MasterContent_rdoStatCat_1").set
        sleep 5
        browser.text_field(:id, "ctl00_MasterContent_txtTIN").set(@micropost.customer.tin)
        begin
          browser.text_field(:id, "ctl00_MasterContent_txtFromAddrs").set("BANGALORE")
        rescue => e
          sleep 3
        end
        sleep 5
        begin
          browser.text_field(:id, "ctl00_MasterContent_txtNameAddrs").set(@micropost.customer.name)
        rescue => e
          sleep 3
        end
      else
        browser.text_field(:id, "ctl00_MasterContent_txtTIN").set(@micropost.customer.tin)
        begin
          browser.text_field(:id, "ctl00_MasterContent_txtFromAddrs").set("BANGALORE")
        rescue => e
          sleep 3
        end
        sleep 3
      end

      sleep 5


      browser.text_field(:id, "ctl00_MasterContent_txtFromAddrs").set(@micropost.user.city)
      browser.text_field(:id, "ctl00_MasterContent_txtToAddrs").set(@micropost.customer.city)
      browser.text_field(:id, "ctl00_MasterContent_txt_commodityname").set(@product.description)
      browser.select_list(:id, "ctl00_MasterContent_ddl_commoditycode").select(@product.description)
      browser.text_field(:id, "ctl00_MasterContent_txtQuantity").set(@stringer)
      browser.text_field(:id, "ctl00_MasterContent_txtNetValue").set(@total)
      browser.text_field(:id, "ctl00_MasterContent_txtVatTaxValue").set(@taxer)
      browser.text_field(:id, "ctl00_MasterContent_txtOthVal").set(@sur)
      sleep 3
      browser.text_field(:id, "ctl00_MasterContent_txtInvoiceNO").set(@micropost.invoice_number.to_s)

      browser.button(:value,"SAVE AND SUBMIT").click
      page_html = Nokogiri::HTML.parse(browser.html)
      browser.button(:value,"Exit").click
      browser.link(:id, "link_signout").click
      browser.close

      textual = page_html.search('//text()').map(&:text).delete_if{|x| x !~ /\w/}
      esugam = textual.fetch(7)

      if esugam !="e-SUGAM New Entry Form"
        flash.now[:success] = esugam
      else
        esugam = nil
        logger.error "esugam not scraped properly ,mostly"
        flash.now[:error]= "There has been an error in generating the esugam,try again later , if the error does not go away check the esugam username and password , if everything is ok and a number is still not generated , contact the webmaster"

      end
      return esugam
    rescue => e
      browser.close
      logger.error " esugam not beiong generetaed " + e.to_s
      esugam = nil
      flash.now[:error] = "There has been an error in generating the esugam,try again later , if the error does not go away check the esugam username and password , if everything is ok and a number is still not generated , contact the webmaster" +e.to_s

    end

  end
  private
  def correct_user
    @micropost =  current_user.microposts.find_by_id(params[:id])
    redirect_to root_url if @micropost.nil?
  end

end