class DeliverablesController < ApplicationController
  
  
  def create
    
    
    @micropost = current_user.microposts.find(Rails.cache.read('mp_id'))
    @deliverable = @micropost.deliverables.build(params[:deliverable])
    if @deliverable.quantity != nil and  @deliverable.unit_price != nil
    @deliverable.del_price = @deliverable.quantity * @deliverable.unit_price
    end
    if @deliverable.save
       @del_items = @micropost.deliverables.find(:all)
       @info = @micropost.infos.build
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js
     end   
    else
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js {render :js => "alert("+@deliverable.errors.full_messages.to_s+");"}
     end   
           
     
      
    
    end
  end
  def edit
    @deliverable = Deliverable.find(params[:id])
    respond_to do |format|
     
      format.js 
    end
   
  end
  def update
    @deliholder = Deliverable.find(params[:id])
    @deliholder.del_price = @deliholder.quantity * @deliholder.unit_price
    if @deliholder.update_attributes(params[:deliverable])
    @micropost = current_user.microposts.find(Rails.cache.read('mp_id'))
   
    @del_items = @micropost.deliverables.find(:all) 
    @info = @micropost.infos.build
    
    
      respond_to do |format|
        format.js 
      end
    else
    respond_to do |format|
        format.html {redirect_to root_path}
        format.js    {render :js => "alert("+@deliverable.errors.full_messages.to_s+");"}
     end 
   end  
  end
  def refresh
    @deliverable = @deliverable = @micropost.deliverables.new
    respond_to do |format|
      format.js
    end
  end
  
end