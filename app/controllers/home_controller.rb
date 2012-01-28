class HomeController < ApplicationController
  def index
    if user_signed_in?
      render :layout => "application"
    else
      render :layout => "welcome"
    end
  end

end
