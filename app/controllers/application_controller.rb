class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_auth
  helper_method :logged_in?

  private
  def check_auth
    redirect_to new_session_path unless logged_in?
  end
  def logged_in?
    if session[:logged_in]
      true
    else
      false
    end
  end
end
