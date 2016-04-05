class Post < ActiveRecord::Base
  include Voteable
  include Sluggable

  # Need to specify foreign key and class name for belongs_to because the column name is "user_id" instead of the default of "creator"
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  sluggable_column :title
end