require 'spec_helper'

feature "my queue" do
  scenario "it adds videos to the queue and change their position" do
    category = Fabricate(:category)
    monk = Fabricate(:video, category: category)
    south_park = Fabricate(:video, category: category)
    futurama = Fabricate(:video, category: category)

    sign_in

    go_to_video(monk)
    expect_to_have_text(monk.description)

    add_video_to_queue(monk)
    visit my_queue_path
    expect_to_have_text(monk.title)

    visit video_path(monk)
    expect_to_not_have_text("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)
    visit my_queue_path

    change_position_in_queue(monk,2)
    change_position_in_queue(south_park,3)
    change_position_in_queue(futurama,1)
    find_button("Update Instant Queue").click

    expect_position_in_queue(monk,2)
    expect_position_in_queue(south_park,3)
    expect_position_in_queue(futurama,1)

  end

  def go_to_video(video)
    find("a[href='/videos/#{video.id}']").click # looks for the link
  end

  def add_video_to_queue(video)
    visit home_path
    go_to_video(video)
    find_link("+ My Queue").click
  end

  def change_position_in_queue(video,new_position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do # tries to find text contained. Link will not work.
      fill_in "queue_items[][position]", with: new_position
    end
  end

  def expect_position_in_queue(video,position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='number']").value).to eq(position.to_s)
  end

  def expect_to_have_text(content)
    expect(page).to have_content(content)
  end

  def expect_to_not_have_text(text)
    expect(page).to_not have_content(text)
  end
end