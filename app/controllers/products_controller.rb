class ProductsController < ApplicationController
  
  def create
    @product = current_user.products.build(params[:product])
    if @product.code == nil
      @product.code = ""
    end
    if @product.save
      flash[:success] = "product saved " 
      if Rails.cache.read('root') == 1
        @deliverable = Deliverable.new
        @product = current_user.products.build
      end
      respond_to do |format|
      @product = current_user.products.build
      object = @product
      format.html  {redirect_to products_url}
      format.js 
      end
    else
      respond_to do |format|
      format.html  {flash[:error] = @product.errors.full_messages.to_s
        redirect_to :back}
      format.js {render :js => "alert("+@product.errors.full_messages.to_s+");"} 
      end
    end
  end
  def new
    @product = current_user.products.build(params[:product])
    
    Rails.cache.write('root',0)
  end
  def edit
     @product = Product.find(params[:id])
     render 'new'
  end
  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to products_path
    else
      flash[:error] = @product.errors.full_messages.to_s
      redirect_to :back
    end
  end
    
  def index
    
    @products = current_user.products.paginate(page: params[:page],:per_page => 10)
    
  
  end
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end
    
  
  
  
  
end