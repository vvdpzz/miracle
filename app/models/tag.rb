class Tag < ActiveRecord::Base
  include Redis::Objects
  
  # redis objects
  set :cached_followers
  set :cached_posts
  
  # sphinx index
  define_index do
    indexes name
  end
end
