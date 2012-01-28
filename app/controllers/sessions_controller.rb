class SessionsController < ApplicationController
  def new
    redirect_to '/auth/github'
  end
  
  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], 
                      :uid => auth['uid']).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    $redis.setbit("login:#{Time.now.strftime('%y%m%d')}", user.id, 1)
    redirect_to root_url
  end
  
  def destroy
    reset_session
    redirect_to root_url
  end
  
  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
