class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  after_create :add_to_denormalized_friends
  after_destroy :remove_from_denormalized_friends
  
  def add_to_denormalized_friends
    user.cached_followings.add friend.id
    friend.cached_followers.add user.id
  end
  
  def remove_from_denormalized_friends
    user.cached_followings.delete friend.id
    friend.cached_followers.delete user.id
  end
end
