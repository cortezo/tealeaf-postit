class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all.sort {|a,b| b.total_votes <=> a.total_votes }[0, 25]
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.sort {|a,b| b.total_votes <=> a.total_votes}[0, 25]
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Post successfully created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
    if @post.creator != current_user
      flash[:warning] = "You cannot edit this post because you didn't create it."
      redirect_to post_path(@post)
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post successfully updated."
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)

    if @vote.valid?
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "You can only vote once."
    end

    redirect_to :back
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    if false  # user.admin?  --- User must be an admin (requires an admin? function that returns t/f)
         params.require(:post).permit!   # Would permit all attributes to be mass-assigned
    else
         params.require(:post).permit(:title, :url, :description, category_ids: [])
    end
  end
end
