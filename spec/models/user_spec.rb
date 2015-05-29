require 'spec_helper'

describe User do
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:email)}
  it {should validate_uniqueness_of(:email)}
  it {should validate_length_of(:password).is_at_least(5).on(:create)}

  it "has to validate email is not correct" do
    user = User.create(full_name: "Bruce Banner", password: "Smash", email: "hulk@test")
    expect(user.errors.messages.any?).to eq(true)
  end

  it "validates email is correct" do
    user = User.create(full_name: "Bruce Banner", password: "Smash", email: "hulk@test.com")
    expect(user.errors.messages.any?).to eq(false)
  end

  describe "#queued?" do
    it "returns true if the video has queue items" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(user.queued_video?(video)).to be_truthy
    end

    it "retuns false if the video has not queue items" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      expect(user.queued_video?(video)).to be_falsy
    end
  end
end