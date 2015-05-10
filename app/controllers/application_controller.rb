class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user

  def logged_in?
    !!current_user
  end

  def current_user
    current ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You need to sign in to do that"
      redirect_to root_path
    end
  end
end
