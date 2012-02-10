class Tag < ActiveRecord::Base
  include Redis::Objects
  
  # redis objects
  set :cached_followers
  set :cached_posts
  
  # sphinx index
  define_index do
    indexes name
  end
  
  def tagged_timeline
    # from, to = (page - 1) * 20, page * 20 - 1
    Post.where(:id => self.cached_posts.members)
  end
end
