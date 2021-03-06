class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  before_action :require_admin, except: [:show]
  
  #def index
  #end

  def show
    @category_posts = @category.posts.sort {|a,b| b.total_votes <=> a.total_votes }
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category created."
      redirect_to root_path
    else
      render :new
    end
  end

  #def edit
  #end

  #def update
  #end

  private 

  def set_category
    @category = Category.find_by(slug: params[:id])
  end

  def category_params
    if false  # user.admin?  --- User must be an admin (requires an admin? function that returns t/f)
         params.require(:category).permit!   # Would permit all attributes to be mass-assigned
    else
         params.require(:category).permit(:name)
    end
  end

end