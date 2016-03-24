class Post < ActiveRecord::Base
  # Need to specify foreign key and class name for belongs_to because the column name is "user_id" instead of the default of "creator"
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  before_save :generate_slug

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def generate_slug
    slug = self.title[0, 50].rstrip.gsub(/\s/, "_").gsub(/\W/, "").gsub("_", "-").downcase
    count = Post.all.select{ |post| post.slug.include?(slug)}.count
    if count == 0
      self.slug = slug
    else
      self.slug = slug + "-" + (count).to_s
    end
  end

  def to_param
    self.slug
  end
end