class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = User.first # TEMPORARILY HARD CODED ToDo:  Change once we have authentication

    if @post.save
      flash[:notice] = "Post successfully created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post successfully updated."
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    if false  # user.admin?  --- User must be an admin (requires an admin? function that returns t/f)
         params.require(:post).permit!   # Would permit all attributes to be mass-assigned
    else
         params.require(:post).permit(:title, :url, :description)
    end
  end
end
