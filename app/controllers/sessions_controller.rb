class SessionsController < ApplicationController
  def new
    
  end

  def create
    
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      # This is being saved in the session cookie.  Only save the ID and not the object.  Object would cause overflow error.
      session[:user_id] = user.id  
      flash[:notice] = "Welcome, #{user.username}."
      redirect_to root_path
    else
      flash[:error] = "There was a problem with your username or password.  Please try again."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil

    flash[:notice] = "You have logged out."
    redirect_to root_path
  end

end