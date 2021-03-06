class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def show
    @posts = @user.posts.sort {|a,b| b.total_votes <=> a.total_votes}[0, 25]
    @comments = @user.comments.sort {|a,b| b.total_votes <=> a.total_votes}[0, 25]
  end

  def create
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
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Account successfully updated."
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :timezone)
  end

  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def require_same_user
    if current_user != @user
      flash[:error] = "You're not allowed to do that"
      redirect_to root_path
    end
  end

end
