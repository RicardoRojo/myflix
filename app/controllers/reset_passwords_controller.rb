class ResetPasswordsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :password_invalid
  def show
    user = User.find_by(token: params[:id])
    if user
      @token = params[:id]
    else
      redirect_to expired_token_path
    end
  end

  def create
    token = params[:token]
    redirect_to root_path and return if token.blank?

    user = User.find_by(token: params[:token])
    if user
      user.update!({password: params[:password], token: nil})
      flash[:success] = "Congratulations, you changed your password."
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end

  protected

  def password_invalid
    @token = params[:token]
    flash[:error] = "Wrong password. Try again!!"
    render :show
  end
end