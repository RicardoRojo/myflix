class FlixMailer < ActionMailer::Base
  default from: "admin@myflix.com"

  def send_welcome_email(user_id)
    ENV['RAILS_ENV'] == "staging" ? @user = User.find_by(email: "admin@myflix.com") : @user = User.find(user_id)
    mail to: @user.email, subject: "Welcome to myflix #{@user.full_name.capitalize}"
  end

  def send_email_with_link(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Reset password link"
  end

  def send_invitation_with_link(invitation_id)
    @invitation = Invitation.find(invitation_id)
    recipient_email = ENV['RAILS_ENV'] == "staging" ? "admin@myflix.com" : @invitation.recipient_email
    mail to: recipient_email, subject: "My flix invitation"
  end
end