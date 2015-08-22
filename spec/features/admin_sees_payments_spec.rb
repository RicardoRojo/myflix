require 'spec_helper'

feature "admin sees payments" do
  background do
    Fabricate(:payment, user: alice,amount: 999)
  end

  let(:alice) {Fabricate(:user)}

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content(alice.email)
    expect(page).to have_content(alice.full_name)
    expect(page).to have_content("$9.99")
  end

  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content(alice.email)
    expect(page).not_to have_content(alice.full_name)
    expect(page).not_to have_content("$9.99")
    expect(page).to have_content("User not allowed to do that")
  end
end