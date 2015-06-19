require 'spec_helper'

# login
# home
# click on video
# click on reviews
# social page of user
# follow
# people includes user
# unfollow
# person not in the list

feature "Social networking" do

  given(:alice) {Fabricate(:user)}
  given(:bob) {Fabricate(:user)}
  given(:drama) {Fabricate(:category)}
  given(:monk) {Fabricate(:video, category: drama)}

  scenario "it follows and unfollow user" do
    review  = Fabricate(:review, video: monk, user: bob, rating: 1, body: "Monk is great")

    sign_in(alice)
    visit home_path

    go_to_video(monk)

    go_to_user(bob)
    expect_followable

    follow_user
    expect_user_followed(bob)

    go_to_user(bob)
    expect_not_followable

    visit people_path
    unfollow_user(bob)

    expect_to_not_have_text(bob.full_name)
  end

  def go_to_user(user)
    find_link("#{user.full_name}").click    
  end

  def expect_followable
    expect(page).to have_link('Follow')
  end

  def expect_not_followable
    expect(page).not_to have_link('Follow')
  end

  def follow_user
    click_link("Follow")
  end

  def unfollow_user(user)
    within(:xpath, "//tr[contains(.,'#{user.full_name}')]") do
      find("a[data-method='delete']").click
    end
  end

  def expect_user_followed(user)
    expect_to_have_text(bob.full_name)
  end

end