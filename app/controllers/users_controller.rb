class UsersController < ApplicationController
  before_filter :signed_in_user, only: [ :edit,:show, :update, :destroy]
  before_filter :correct_user, only: [:edit,:show, :update]
  before_filter :admin_user, only: [:destroy,:index]
  def show
    @user = User.find(params[:id])
    
   
    @microposts = @user.microposts.paginate(page: params[:page] )
     @feed_items = @microposts
    @tax = @user.taxes.build
    @category = @user.categories.build
    @cat_feed_list = @user.cat_feed
    @tax_feed_list = @user.tax_feed
    
  end
  def new
    if signed_in?
      flash[:error] = "you already are a member who has signed in "
      redirect_to root_path
    
    else
      @user = User.new
      
    end
  end
  def index
    @users = User.paginate(page: params[:page])  
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_url
  end
  def create
    if signed_in?
      
      redirect_to root_path
    else
      @user = User.new(params[:user])
      
      if @user.save
        @customer = @user.customers.new(name:"Cash",tin:"00000000000",phone:"0000000",address:"",city:"bangalore",email:"cash@example.com")
        if @customer.save
          sign_in @user
          flash[:success]="Welcome to onwebaccount.in !"
          redirect_to @user
        
        else
          flash[:error]="there was an interrnal error sorry ,"+@customer.errors.full_messages.to_s
        render 'new'
        end
      else
       
        render 'new'
      end
    end
  end
  def edit
   
    render 'new'
    
  end
  def update
    
    if @user.update_attributes(params[:user])
      
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end
  private
  
    
  
  def correct_user
    @user = User.find(params[:id])
    @cuser = User.find_by_remember_token(cookies[:remember_token])
    redirect_to @cuser unless current_user?(@user)
  end
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
 end
  
  
  

