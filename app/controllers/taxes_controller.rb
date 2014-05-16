class TaxesController < ApplicationController
  
  def create
    @user = current_user
    @tax = @user.taxes.build(params[:tax])
    
    if @tax.save
      @tax_feed_list = current_user.taxes.find(:all)
      respond_to do |format|
      format.html {redirect_to user_path(current_user)}
      format.js
      end
    else
      respond_to do |format|
        format.js {render :js => "alert("+@tax.errors.full_messages.to_s+");"}
        format.html {redirect_to user_path(current_user)}   
      end
    end
  end
  def destroy
    @tax = current_user.taxes.find(params[:id])
    @tax.destroy
    @tax_feed_list = current_user.taxes.find(:all)
    respond_to  do |format|
      format.js
      format.html {redirect_to user_path(current_user)}
    end
  end
  def refresh
    @tax_feed_list = current_user.taxes.find(:all)
    respond_to  do |format|
      format.js
      format.html {redirect_to user_path(current_user)}
    end
  end
  def edit
    @tax = Tax.find(params[:id])
    respond_to do |format|
     
      format.js 
    end
  end
  def update
    @tax = Tax.find(params[:id])
    if @tax.update_attributes(params[:tax])
      @tax_feed_list = current_user.taxes.find(:all)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
         format.js    {render :js=> "alert("+@tax.errors.full_messages.to_s+");"}
      end
    end
  end
  
    
    

  
end