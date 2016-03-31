class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  before_save :generate_slug

  validates :name, presence: true, uniqueness: true, length: {maximum: 20}, format: { with: /\A[a-zA-Z0-9\s{1}]+\Z/}

  def generate_slug
    self.slug = self.name.strip.gsub(/\s+/, "-").downcase
  end

  def to_param
    self.slug
  end
end