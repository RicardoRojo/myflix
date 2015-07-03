class FlixMailer < ActionMailer::Base
  default from: "admin@myflix.com"

  def send_welcome_email(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Welcome to myflix #{@user.full_name.capitalize}"
  end

  def send_email_with_link(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Reset password link"
  end

  def send_invitation_with_link(invitation_id)
    i = 1/0
    @invitation = Invitation.first
    mail to: @invitation.recipient_email, subject: "My flix invitation"
  end
end