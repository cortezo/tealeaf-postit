class UpdateSlugForSluglessEntries2 < ActiveRecord::Migration
  def change
    Post.all.each do |post|
      slug = post.title.rstrip.gsub(/\s/, "_").gsub(/\W/, "").gsub("_", "-").downcase
      post.slug = slug
      post.save
    end
  end
end
