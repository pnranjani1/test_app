class StaticPagesController < ApplicationController
  def home
    if signed_in?
      if current_user.categories.count == 0 or current_user.taxes.count == 0
        redirect_to user_path(current_user) and return
      end
      Rails.cache.write("root",1)
      Rails.cache.write('mp_id',nil)
      
      @customer = current_user.customers.build
      
      @micropost = current_user.microposts.build
     
      @del_items = @micropost.deliverables.find(:all)
      @product = current_user.products.build
      @deliverable = @micropost.deliverables.build
      @info = @micropost.infos.build
     
      @feed_items = current_user.feed.paginate(page: params[:page],:per_page => 8) 
      
      
    end
     
  end

  def help
  end
  
  def about
  end
  
  def contact
    
  end
end
