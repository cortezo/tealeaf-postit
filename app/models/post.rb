class Post < ActiveRecord::Base
  # Need to specify foreign key and class name for belongs_to because the column name is "user_id" instead of the default of "creator"
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
end