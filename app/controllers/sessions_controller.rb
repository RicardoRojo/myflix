class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def new
    redirect_to home_path unless !logged_in?
  end
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome again #{user.full_name}"
      redirect_to home_path
    else
      flash[:danger] = "Invalid user or password.Please try again"
      render :new, params
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end