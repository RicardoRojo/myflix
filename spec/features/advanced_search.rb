require 'spec_helper'

feature "User interacts with advanced search", :elasticsearch do

  background do
    star_wars1 = Fabricate(:video, title: "Star Wars: Episode 1")
    star_wars2 = Fabricate(:video, title: "Star Wars: Episode 2")
    star_trek  = Fabricate(:video, title: "Star Trek")
    bride_wars = Fabricate(:video, title: "Bride Wars", description: "some wedding movie!")
    refresh_index
    sign_in
  end

  scenario "user searches with title" do
    click_on "Advanced Search"

    within(".advanced_search") do
      fill_in "query", with: "Star Wars"
      click_button "Search"
    end

    expect(page).to have_content("2 videos found")
    expect(page).to have_content("Star Wars: Episode 1")
    expect(page).to have_content("Star Wars: Episode 2")
    expect(page).to have_no_content("Star Trek")
  end

  scenario "user searches with title and description" do
    click_on "Advanced Search"

    within(".advanced_search") do
      fill_in "query", with: "wedding movie"
      click_button "Search"
    end
    expect(page).to have_content("Bride Wars")
    expect(page).to have_no_content("Star")
  end
end

def refresh_index
  Video.import
  Video.__elasticsearch__.refresh_index!
end