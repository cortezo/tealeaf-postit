class CommentsController < ApplicationController
  before_action :require_user
  before_action :set_post

  def create
    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Your comment was added"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @comment = @post.comments.find(params[:id])
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash.now[:notice] = "Your vote was counted."
        else
          flash.now[:error] = "You can only vote once per comment."
        end
        redirect_to :back
      end
      format.js
    end
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:post_id])
  end
end