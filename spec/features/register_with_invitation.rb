require 'spec_helper'

feature "invite and register with token" do
  scenario "invites a user", { js: true, vcr: true } do
    clear_emails
    
    alice = Fabricate(:user)
    bob   = Fabricate.build(:user)
    sign_in(alice)

    click_link "Welcome #{alice.full_name}"
    find_link("Invite").trigger('click')

    expect_to_have_text("Invite a friend to join MyFlix!")

    send_invitation(bob,"Join MyFlix, it´s great")

    click_link "Welcome #{alice.full_name}"
    sign_out

    open_email(bob.email)
    expect_email("Join MyFlix, it´s great")
    
    click_email_link_and_signup(bob)
    sleep 3
    expect_to_have_text("Welcome #{bob.full_name}")

    expect_following(alice)

    click_link "Welcome #{bob.full_name}"
    save_screenshot('tmp/bob_signup.png')
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
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2017", from: "date_year"
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