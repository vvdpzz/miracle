class PostsController < ApplicationController
  def index
    @posts = current_user.home_timeline
  end
  
  def create
    @post = current_user.posts.build params[:post]
    @post.save if not @post.text.nil?
  end
  
  def tagged
    @tag = Tag.find_by_name params[:id]
    if @tag
      @posts = @tag.tagged_timeline
      @users = @tag.tagged_follower
    end
  end
  
  def search
    @posts = Post.search params[:q]
  end
end
