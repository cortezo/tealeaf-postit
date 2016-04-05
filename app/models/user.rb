class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\Z/}
  validates :password, presence: true, on: :create, length: { minimum: 3, maximum: 20 }

  sluggable_column :username

  def admin?
    self.role == "admin"
  end
end
