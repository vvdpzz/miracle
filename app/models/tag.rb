class Tag < ActiveRecord::Base
  include Redis::Objects
  
  # redis objects
  set :cached_followers
  set :cached_posts
end
