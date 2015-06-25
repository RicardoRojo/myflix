require 'spec_helper'

feature "invite and register with token" do
  scenario "invites a user" do
    clear_emails
    
    alice = Fabricate(:user)
    bob   = Fabricate.build(:user)
    sign_in(alice)

    click_link "Invite friends"
    expect_to_have_text("Invite a friend to join MyFlix!")

    send_invitation(bob,"Join MyFlix, it´s great")
    sign_out

    open_email(bob.email)
    expect_email("Join MyFlix, it´s great")
    
    click_email_link_and_signup(bob)
    expect_to_have_text("Welcome #{bob.full_name}")

    expect_following(alice)

    sign_out

    click_email_link_and_expect_expired_link_page

    sign_in(alice)
    expect_following(bob)

  end

  def send_invitation(user, message)
    fill_in "Friend's Name", with: user.full_name
    fill_in "Friend's Email Address", with: user.email
    fill_in "Invitation Message", with: message
    click_button("Send Invitation")
  end

  def expect_email(message)
    expect(current_email).to have_content(message)
  end

  def click_email_link_and_signup(user)
    current_email.click_link "Join my flix"
    expect_field_with_email(user)
    expect(find_field('Email').value).to eq(user.email)
    fill_in "Password", with: user.password
    fill_in "Full name", with: user.full_name
    click_button "Sign Up"
  end

  def expect_field_with_email(user)
    expect(find_field('Email').value).to eq(user.email)
  end

  def click_email_link_and_expect_expired_link_page
    current_email.click_link "Join my flix"
    expect_to_have_text("Your link is expired.")
  end

  def expect_following(user)
    click_link "People"
    expect_to_have_text(user.full_name)
  end
end