class SessionsController < ApplicationController
  skip_before_filter :check_auth, :only => [:new, :create]

  def new
  end

  def create
    if params[:password] == ADMIN_PASSWORD
      session[:logged_in] = true
    end
    redirect_to root_path
  end

  def logout
    session[:logged_in] = nil
    redirect_to new_session_path
  end
end
