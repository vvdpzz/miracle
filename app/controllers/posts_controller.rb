class PostsController < ApplicationController
  def index
    @posts = current_user.home_timeline
  end
  
  def create
    @post = current_user.posts.build params[:post]
    @post.save if not @post.text.nil?
  end
end
