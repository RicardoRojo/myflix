class UsersController < ApplicationController
  def new
    redirect_to home_path unless !logged_in?
    @user = User.new
  end
  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.full_name}!!"
      redirect_to home_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :password, :email)
  end
end