require 'spec_helper'

feature "Adding video" do
  scenario "admin adds video" do
    alice = Fabricate(:admin)
    dramas = Fabricate(:category, name: "Dramas")

    sign_in(alice)
    visit new_admin_video_path

    create_record

    sign_out
    sign_in

    visit video_path(Video.last)
    expect(page).to have_selector("img[src='/uploads/video/large_cover/#{Video.last.id}/large_cover.png']")
    expect(page).to have_selector("a[href='http://www.example.com/test.mp4']")

    visit home_path
    expect(page).to have_selector("img[src='/uploads/video/small_cover/#{Video.last.id}/small_cover.png']")

  end

  def create_record
    fill_in "Title", with: "test"
    select "Dramas", from: "Category"
    fill_in "Description", with: "test video description"
    attach_file('Large Cover', "spec/support/uploads/large_cover.png")
    attach_file('Small Cover', "spec/support/uploads/small_cover.png")
    fill_in "Video url", with: "http://www.example.com/test.mp4"
    click_button "Add video"
  end
end