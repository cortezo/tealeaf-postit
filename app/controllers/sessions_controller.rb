class SessionsController < ApplicationController
  def new
    
  end

  def create
    
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = "There was a problem with your username or password.  Please try again."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to root_path
  end

end