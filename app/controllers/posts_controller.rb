class PostsController < ApplicationController
  def index
    @posts = current_user.home_timeline
  end
  
  def create
    @post = current_user.posts.build params[:post]
    @post.save if not @post.text.nil?
  end
  
  def tagged
    tag = Tag.find_by_name params[:id]
    @posts = tag.tagged_timeline if tag
  end
end
