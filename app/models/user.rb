class User < ActiveRecord::Base
  include Redis::Objects
  
  attr_accessible :provider, :uid, :name, :nickname, :email, :bio, :location, :avatar_url, :html_url
  
  # relations
  has_many :posts
  
  has_many :followers, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :friends, :class_name => "Friendship", :foreign_key => "user_id"
  
  # sphinx index
  define_index do
    indexes name, :sortable => true
    indexes nickname, :sortable => true
    
    has created_at
  end
  
  # redis objects
  set :cached_followings
  set :cached_followers
  set :cached_tags
  list :cached_timeline
  counter :cached_offset
  # cached New Posts Count
  counter :cached_npc
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        %w(name nickname email).each do |field|
          user[field] = auth['info'][field] || ""
        end
      end
      if auth['extra']
        %w(bio location avatar_url html_url).each do |field|
          user[field] = auth['extra']['raw_info'][field] || ""
        end
      end
      if auth['credentials']
        user['token'] = auth['credentials']['token'] || ""
      end
    end
  end
  
  def home_timeline(page = 1)
    self.cached_offset.reset if page == 1
    offset = self.cached_offset.value
    from, to = (page - 1) * 20 + offset, (page * 20) + offset - 1
    Post.where(:id => self.cached_timeline[from..to].to_a)
  end
  
  def newest_posts
    npc = self.cached_npc.value
    if npc > 0
      self.cached_npc.reset
      Post.where(:id => self.cached_timeline[0..npc-1].to_a)
    end
  end
  
  def follow_user(friend_id)
    self.id == friend_id ? false : Friendship.find_or_create_by_user_id_and_friend_id(self.id, friend_id)
  end
  
  def unfollow_user(friend_id)
    self.id == friend_id ? false : Friendship.find_by_user_id_and_friend_id(self.id, friend_id).destroy
  end
  
  def follow_tag(tag_id)
    Tagship.find_or_create_by_user_id_and_tag_id(self.id, tag_id)
  end
  
  def unfollow_tag(tag_id)
    Tagship.find_by_user_id_and_tag_id(self.id, tag_id).destroy
  end
end
