class PostsController < ApplicationController
  PER_PAGE = 5

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_creator, only: [:edit, :update]

  def index
    Post.update_all_scores  #For a larger app... make this a timed task or find some other way to regularly update the score to drop old or unpopular items off the list
    @posts = Post.order(score: :desc).limit(PER_PAGE).offset(params[:offset])
    @pages = (Post.all.count.to_f / PER_PAGE).ceil

    respond_to do |format|
      format.html
      format.json { render json: @posts }
      format.xml { render xml: @posts }
    end
  end

  def show
    @post_comments = @post.comments.sort {|a,b| b.total_votes <=> a.total_votes}[0, 25]
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.json { render json: @post }
      format.xml { render xml: @post }
    end
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

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You can only vote once per post."
        end
        redirect_to :back
      end
      
      format.js
    end
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def post_params
    if false  # user.admin?  --- User must be an admin (requires an admin? function that returns t/f)
         params.require(:post).permit!   # Would permit all attributes to be mass-assigned
    else
         params.require(:post).permit(:title, :url, :description, category_ids: [])
    end
  end

  def require_creator
    access_denied unless logged_in? and (@post.creator == current_user or current_user.admin?)
  end
end
