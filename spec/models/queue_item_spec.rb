require 'spec_helper'

describe QueueItem do
  it {should belong_to(:user)}
  it {should belong_to(:video)}

  describe "#video_title" do
    it "shows the title of the video" do
      video1 = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video1)
      expect(queue_item.video_title).to eq(video1.title)
    end
  end

  describe "#category_name" do
    it "shows the name of the category" do
      category = Fabricate(:category)
      video1 = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video1)
      expect(queue_item.category_name).to eq(category.name)
    end
  end

  describe "#rating" do
    it "shows nil value if no rating is set" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be(nil)
    end

    it "shows review rating for the video if is set" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, video: video, user: user)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.rating).to eq(review.rating)
    end
  end

  describe "#category" do
    it "returns the category of the video in the queue" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end

  describe "#rating=" do
    it "returns the new rating if the rating changes" do
      alice = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: alice, video: video, rating: 1)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      queue_item.rating = 3
      expect(queue_item.rating).to eq(3)
    end

    it "creates a new rating if rating was not set" do
      alice = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      queue_item.rating = 3
      expect(queue_item.rating).to eq(3)
    end

    it "deletes the old rating if the rating is set to nil" do
      alice = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: alice, video: video, rating: 1)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end
  end
end