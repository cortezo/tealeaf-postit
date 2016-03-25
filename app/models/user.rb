class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  before_save :generate_slug

  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\Z/}
  validates :password, presence: true, on: :create, length: { minimum: 3, maximum: 20 }

  def generate_slug
    self.slug = self.username.downcase
  end

  def to_param
    self.slug
  end
end
