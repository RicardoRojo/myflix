require 'spec_helper'

feature "User registration", {js: true, vcr: true} do

  let(:invalid_card) {"123"}
  let(:valid_card) {"4242424242424242"}
  let(:declined_card) {"4000000000000002"}

  background do
    visit register_path
  end

  scenario "valid user information and valid card" do

    fill_in_valid_user(true)
    fill_in_card(valid_card)
    sign_up

    expect(page).to have_content("Welcome alice!!")

  end

  scenario "valid user information and invalid card" do

    fill_in_valid_user(true)
    fill_in_card(invalid_card)
    sign_up

    expect(page).to have_content("This card number looks invalid.")
  end

  scenario "valid user information and declined card" do

    fill_in_valid_user(true)
    fill_in_card(declined_card)
    sign_up

    expect(page).to have_content("Your card was declined.")

  end

  scenario "invalid user information and valid card" do

    fill_in_valid_user(false)
    fill_in_card(valid_card)
    sign_up

    expect(page).to have_content("User information is not correct.Please review")
  end

  scenario "invalid user information and invalid card" do

    fill_in_valid_user(false)
    fill_in_card(invalid_card)
    sign_up

    expect(page).to have_content("This card number looks invalid.")

  end

  scenario "invalid user information and declined card" do

    fill_in_valid_user(false)
    fill_in_card(declined_card)
    sign_up

    expect(page).to have_content("User information is not correct.Please review")
  end
end

def fill_in_card(card)
  fill_in "Credit Card Number", with: card
  fill_in "Security Code", with: "123"
  select "7 - July", from: "date_month"
  select "2018", from: "date_year"
end

def fill_in_valid_user(valid=true)
  fill_in "Email",      with: "alice@test.com" if valid
  fill_in "Password",   with: "123456"
  fill_in "Full name",  with: " alice"
end

def sign_up
  click_button "Sign Up"
end