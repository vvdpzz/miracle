class PostTag < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag
  
  after_create :add_to_denormalized_tags
  after_destroy :remove_from_denormalized_tags
  
  def add_to_denormalized_tags
    post.cached_tags.add tag.id
    if not tag.cached_posts.member? post.id
      tag.cached_posts.add post.id
      tag.ctt.unshift post.id
    end
  end
  
  def remove_from_denormalized_tags
    post.cached_tags.delete tag.id
    tag.cached_posts.delete post.id
    tag.ctt.delete post.id
  end
end
