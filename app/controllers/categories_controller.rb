class CategoriesController < ApplicationController
  
  def create
    @user = current_user
    @category = @user.categories.build(params[:category])
    
    if @category.save
      @cat_feed_list = current_user.categories.find(:all)
      respond_to do |format|
      format.html {redirect_to user_path(current_user)}
      format.js
      end
    else
      respond_to do |format|
        format.js {render :js => "alert("+@category.errors.full_messages.to_s+");"}
        format.html {redirect_to user_path(current_user)}   
      end
    end
  end
  def destroy
    @category = current_user.categories.find(params[:id])
    @category.destroy
    @cat_feed_list = current_user.categories.find(:all)
    respond_to  do |format|
      format.js
      format.html {redirect_to user_path(current_user)}
    end
  end
  def refresh
    @cat_feed_list = current_user.categories.find(:all)
    respond_to  do |format|
      format.js
      format.html {redirect_to user_path(current_user)}
    end
  end
  def edit
    @category = Category.find(params[:id])
    respond_to do |format|
     
      format.js 
    end
  end
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      @cat_feed_list = current_user.categories.find(:all)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
         format.js    {render :js=> "alert("+@category.errors.full_messages.to_s+");"}
      end
    end
  end
  
    
    

  
end