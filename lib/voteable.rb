# Using concerns (rails thing), equivalent to below.
module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable
  end

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end
end

# Using normal metaprogramming
=begin
module Voteable
  extend ActiveSupport::Concern
  
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.extend ClassMethods
    base.class_eval do   # Fires off this code whenever the module is included in a class.
      my_class_method
    end
  end

  module InstanceMethods
    def total_votes
      up_votes - down_votes
    end

    def up_votes
      self.votes.where(vote: true).size
    end

    def down_votes
      self.votes.where(vote: false).size
    end
  end

  module ClassMethods
    def my_class_method
      has_many :votes, as: :voteable
    end
  end
end
=end