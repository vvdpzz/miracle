class UsersController < ApplicationController
  def show
    user = User.find_by_nickname params[:id]
    
    hash = {}
    
    if current_user.id == user.id
      hash[:is_self] = 1
    else
      hash[:is_self] = 0
    end
    
    if user.cached_followers.member? current_user.id
      hash[:is_following] = 1
    else
      hash[:is_following] = 0
    end
    
    render :json => user.serializable_hash.merge(hash), status: :ok
  end
end
