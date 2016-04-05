module Sluggable
  # This essentially says that all methods defined here will be mixed in as 
  # instance methods when this module is included in a class elsewhere.
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    class_attribute :slug_column
  end

  def generate_slug!
    the_slug = to_slug(self.send(self.class.slug_column.to_sym))

    first_loop_pass = true
    loop do
      # self.class replaces Post. or Category.
      obj = self.class.find_by slug: the_slug
      if obj && obj != self
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

    self.slug = the_slug.downcase
  end

  def append_suffix(str)
    slug_array = str.split("-") 
    num = slug_array.last.to_i + 1
    slug_array.pop
    slug_array << num.to_s
    return slug_array.join "-"
  end

  def to_slug(name)
    str = name.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, '-'
    str.gsub! /-+/, '-'
    str.downcase[0, 50]
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end
