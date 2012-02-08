class FriendshipsController < ApplicationController
  def create
    friend = User.find params[:user_id]
    if friend and current_user.follow_user friend.id
      render :json => {key: 0, comment: "success"}, :status => :ok
    else
      render :json => {key: 1, comment: "failed"}, :status => :ok
    end
  end
  
  def destroy
    friend = User.select("id").find_by_id params[:id]
    if friend and current_user.unfollow_user friend.id
      render :json => {key: 0, comment: "success"}, :status => :ok
    else
      render :json => {key: 1, comment: "failed"}, :status => :ok
    end
  end
end
