class Category < ActiveRecord::Base
  include Sluggable

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true, length: {maximum: 20}, format: { with: /\A[a-zA-Z0-9\s{1}]+\Z/}

  sluggable_column :name
end