class Post < ActiveRecord::Base
  include Twitter::Extractor
  include Twitter::Autolink
  include Redis::Objects
  
  # relations
  belongs_to :user, :counter_cache => true
  has_many :post_tags
  
  # scopes
  default_scope order("created_at desc")
  
  # callbacks
  before_create :set_user_properties
  after_create :asyncs
  after_create :cache_replies
  
  # sphinx index
  define_index do
    indexes text
    has created_at
    
    set_property :delta => true
  end
  
  # redis objects
  set :cached_tags
  list :cached_replies
  
  def replies
    Post.where(id: self.cached_replies.values)
  end
  
  protected
    def set_user_properties
      self.name = self.user.name
      self.nickname = self.user.nickname
      self.avatar_url = self.user.avatar_url
      self.in_reply_to_user_id = self.user_id if self.in_reply_to_post_id
    end

    def asyncs
      Resque.enqueue(ExtractTag, self.id)
      Resque.enqueue(NewPost, self.id)
    end
    
    def cache_replies
      $redis.rpush("post:#{self.in_reply_to_post_id}:cached_replies", self.id) if self.in_reply_to_post_id
    end
end
