class Tag < ActiveRecord::Base
  include Redis::Objects
  
  # redis objects
  set :cached_followers
  # set :cached_posts
  # cached_tagged_timeline
  list :ctt
  
  # sphinx index
  define_index do
    indexes name
  end
  
  def tagged_timeline page = 1
    from, to = (page - 1) * 20, page * 20 - 1
    Post.where(:id => self.ctt[from..to].to_a)
  end
  
  def tagged_follower
    User.select("id, name, nickname, avatar_url, bio").where(:id => self.cached_followers.members)
  end
end
