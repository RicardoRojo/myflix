class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.full_name}!!"
      FlixMailer.delay.send_welcome_email(@user.id)
      handle_invitation
      redirect_to home_path
    else
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

  def handle_invitation
    invitation = Invitation.find_by(token: params[:invitation_token])
    if invitation
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.remove_token!
    end
  end
end