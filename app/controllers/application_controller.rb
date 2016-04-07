class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :require_admin

  # before_action :set_time_zone

  # def set_time_zone
  #   if logged_in?
  #     Time.zone = current_user.timezone
  #   end
  # end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_admin
    access_denied unless logged_in? and current_user.admin?
  end

  def require_user
    access_denied unless logged_in?
  end

  def access_denied
    flash[:error] = "You cannot do that."
    redirect_to root_path
  end
end
