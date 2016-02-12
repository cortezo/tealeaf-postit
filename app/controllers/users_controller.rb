class UsersController < ApplicationController

  before_action :require_user, only: [:edit, :update]

  def create
    binding.pry
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Account successfully created."
      session[:user_id] = @user.id
      @current_user = @user
      redirect_to root_path
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.udpate(user_params)

    if @user.save
      flash[:notice] = "Account successfully updated."
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
