class CustomersController < ApplicationController
  before_filter :signed_in_user, only: [:create, :show, :index]
  before_filter :correct_user, only: [ :destroy , :show ,:edit ]
  autocomplete :customer, :name
  def index
    @customers = current_user.customers.paginate(page: params[:page])
    
  end
  def create
    object = @customer
    @customer = current_user.customers.build(params[:customer])
    object = @customer
   
    if @customer.save
      if Rails.cache.read('mp_id')==nil
        @micropost = current_user.microposts.build
      else
        @micropost = current_user.microposts.find(Rails.cache.read('mp_id'))
      end
      if Rails.cache.read('root') == 1
        respond_to do |format|
          @customer = current_user.customers.build()
          format.html {redirect_to :back}
          format.js
          
        end
        
        
      else
        redirect_to customers_url
        
      end
    else
      respond_to do |format|
      format.html {redirect_to :back 
        flash[:error] = @customer.errors.full_messages.to_s}
      format.js {render :js => "alert("+@customer.errors.full_messages.to_s+");"}
      end
    end
   
  end
  def destroy
    @customer.destroy
    redirect_to customers_url
    

  end
  def edit
    render 'new'
    @object = @customer
  end
  def update
    @customer = current_user.customers.find_by_id(params[:id])
    @object = @customer
    if  @customer.update_attributes(params[:customer])
      flash[:success] = "Customer information updated"
      redirect_to @customer
    else
      respond_to do |format|
      format.html {redirect_to :back 
        flash[:error] = @customer.errors.full_messages.to_s}
      end
    end
  end
  def new
    @customer=Customer.new
    @object = @customer
    Rails.cache.write('root',0)
    
  end
  def show
    @customer=current_user.customers.find_by_id(params[:id])
    
  end
  
  private
    def correct_user
      
      @customer =  current_user.customers.find_by_id(params[:id])
      redirect_to root_url if @customer.nil?
    end
  
end