require "spec_helper"

feature "Password reset" do
  scenario "with valid email" do
    clear_email
    alice = Fabricate(:user, password: "12345")

    expect_password_change(alice)

    visit_link_in_user_email(alice)
    expect_reset_password_page
    
    expect_succesful_password_change("123456")

    expect_successful_login(alice,"123456")

    visit_link_in_user_email(alice)
    expect_expired_token_page
  end

  def request_password_change(user)
    visit sign_in_path
    click_link "Forgot password?"
    fill_in "Email Address" , with: user.email
    click_button "Submit"
  end

  def expect_password_change(user)
    request_password_change(user)
    expect(page).to have_content("We have send an email with instruction to reset your password.")
  end

  def visit_link_in_user_email(user)
    open_email(user.email)
    current_email.click_link("Change my email")
  end

  def expect_reset_password_page
    expect(page).to have_content("Reset Your Password")
  end

  def expect_succesful_password_change(password)
    fill_in :password, with: password
    click_button "Reset Password"
    expect(page).to have_content("Congratulations")
  end

  def expect_successful_login(user,password)
    visit sign_in_path
    fill_in :email, with: user.email
    fill_in :password, with: password
    click_button "Sign in"
    expect(page).to have_content("Welcome again")
  end
  def expect_expired_token_page
    expect(page).to have_content("Your reset password link is expired.")
  end
end