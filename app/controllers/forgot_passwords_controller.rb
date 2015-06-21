class ForgotPasswordsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_token
      FlixMailer.send_email_with_link(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:error] = params[:email].blank? ? "Email cant be blank" :
                                              "Your email is not in our database. Maybe you misspelled it?"
      redirect_to forgot_password_path
    end
  end

end