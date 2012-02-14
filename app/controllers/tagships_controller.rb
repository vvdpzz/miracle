class TagshipsController < ApplicationController
  def create
    tag = Tag.find params[:tag]
    if tag and current_user.follow_tag tag.id
      render :json => {key: 0, comment: "success"}, :status => :ok
    else
      render :json => {key: 1, comment: "failed"}, :status => :ok
    end
  end
  
  def destroy
    tag = Tag.select("id").find_by_id params[:id]
    if tag and current_user.unfollow_tag tag.id
      render :json => {key: 0, comment: "success"}, :status => :ok
    else
      render :json => {key: 1, comment: "failed"}, :status => :ok
    end
  end
end
