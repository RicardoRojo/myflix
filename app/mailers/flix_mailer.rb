class FlixMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: "admin@myflix.com", to: user.email, subject: "Welcome to myflix #{user.full_name.capitalize}"
  end

  def send_email_with_link(user)
    @user = user
    mail from: "admin@myflix.com", to: user.email, subject: "Reset password link"
  end
end