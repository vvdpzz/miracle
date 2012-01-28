class PostsController < ApplicationController
  def index
    posts = current_user.home_timeline
    render :json => posts, status: :ok
  end
  
  def create
    post = current_user.posts.build params[:post]
    if post.text.nil?
      hash = {key: 1, comment: "Post body must be present"}
    elsif post.save
      hash = post
    else
      hash = {key: 9, comment: "Database error"}
    end
    render :json => hash, status: :ok
  end
end
