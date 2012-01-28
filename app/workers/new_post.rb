class NewPost
  @queue = :new_post
  
  def self.perform(post_id)
    post = Post.find post_id
    
    my_id = post.user_id.to_s
    
    # collect followers
    followers = []
    post.cached_tags.each {|tag_id| followers += $redis.smembers("tag:#{tag_id}:cached_followers")}
    followers += $redis.smembers("user:#{post.user_id}:cached_followers")
    followers.uniq!
    followers.delete my_id
    
    # write into my timeline
    $redis.lpush("user:#{my_id}:cached_timeline", post_id)
    $redis.incr("user:#{my_id}:cached_offset")
    
    # write into their timeline
    followers.each do |follower|
      $redis.lpush("user:#{follower}:cached_timeline", post_id)
      $redis.incr("user:#{follower}:cached_offset")
      $redis.incr("user:#{follower}:cached_npc")
    end
  end
end
