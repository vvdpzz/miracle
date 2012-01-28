class Tagship < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  
  after_create :add_to_denormalized_tags
  after_destroy :remove_from_denormalized_tags
  
  def add_to_denormalized_tags
    user.cached_tags.add tag.id
    tag.cached_followers.add user.id
  end
  
  def remove_from_denormalized_tags
    user.cached_tags.delete tag.id
    tag.cached_followers.delete user.id
  end
end
