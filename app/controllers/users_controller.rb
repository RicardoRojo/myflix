class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).signup(params[:stripe_token],params[:invitation_token])

    if result.successful?
      flash[:success] = "Welcome #{@user.full_name}!!"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash[:error] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :password, :email)
  end

end