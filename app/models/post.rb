class Post < ActiveRecord::Base
  include Voteable

  # Need to specify foreign key and class name for belongs_to because the column name is "user_id" instead of the default of "creator"
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  before_save :generate_slug

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  def generate_slug
    the_slug = self.title.strip
    the_slug = to_slug(the_slug)

    first_loop_pass = true
    loop do
      post = Post.find_by slug: the_slug
      if post && post != self
        if first_loop_pass # This catches titles that end in a number and adds a "-2" instead in incrementing existing number.
          the_slug = the_slug + "-2"
          first_loop_pass = false
        else
          the_slug = append_suffix(the_slug)
        end
      else
        break
      end
    end

    self.slug = the_slug
  end

  def append_suffix(str)
    slug_array = str.split("-") 
    num = slug_array.last.to_i + 1
    slug_array.pop
    slug_array << num.to_s
    return slug_array.join "-"
  end

  def to_slug(name)
    str = name.gsub /\s*[^A-Za-z0-9]\s*/, '-'
    str.gsub! /-+/, '-'
    str.downcase[0, 50]
  end

  def to_param
    self.slug
  end
end