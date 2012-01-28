class UsersController < ApplicationController
  def show
    user = User.find_by_nickname params[:id]
    render :json => user, status: :ok
  end
end
