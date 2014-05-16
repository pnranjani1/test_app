class SessionsController < ApplicationController
  def new
    
  end
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
      #do some stiff
    else
      flash.now[:error] = "Invalid email/passowrd combination"
      render 'new'
      #do som,ke ohter shit 
   end
    
    
  end
  def destroy
    sign_out
    redirect_to root_url
    
  end
end
