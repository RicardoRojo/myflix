require 'spec_helper'

feature "User sign in" do
  background do
    Fabricate(:user, email: "alice@test.com", password: "12345", full_name: "Alice")
    visit sign_in_path
    fill_in "email", with: "alice@test.com"
  end

  scenario "with valid credentials it signs in user" do
    fill_in "password", with: "12345"
    click_button "Sign in"
    expect(page).to have_content "Welcome again Alice"
  end

  scenario "with invalid credentials user is not signed in" do
    fill_in "password", with: "1234"
    click_button "Sign in"
    expect(page).to have_content "Invalid user or password.Please try again"
  end

  scenario "with user deactivated it does not sign in user" do
    alice = Fabricate(:user, active: false)
    sign_in(alice)
    expect(page).to have_content "The user is disabled, Please contact customer service"
    expect(page).not_to have_content alice.full_name
  end
end