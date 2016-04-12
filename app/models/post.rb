class Post < ActiveRecord::Base
  include Sluggable
  include Voteable

  # Need to specify foreign key and class name for belongs_to because the column name is "user_id" instead of the default of "creator"
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  sluggable_column :title

  def set_score
    score = self.comments.count
    score += self.total_votes
    post_time = self.created_at.time
    now = Time.now
    score -= (now - post_time).to_i / (24*60*60)
    self.score = score
    self.save
  end

  def self.update_all_scores  #self. for class method
    Post.all.each do |p|
      p.set_score
    end    
  end
end