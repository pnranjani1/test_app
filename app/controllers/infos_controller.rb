class InfosController < ApplicationController
  def new
  end
  def create
    @micropost = current_user.microposts.find(Rails.cache.read('mp_id'))
    @info = @micropost.infos.build(params[:info])
    if @info.save
     redirect_to micropost_path(Rails.cache.read('mp_id'))
        
     
    else
      respond_to do |format|
        format.html {redirect_to root_path}
        format.js {render :js => "alert("+@info.errors.full_messages.to_s+");"}
      end
    end
  end
end
