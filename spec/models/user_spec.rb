require 'spec_helper'

describe User do
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:email)}
  it {should validate_uniqueness_of(:email)}
  it {should validate_length_of(:password).is_at_least(5).on(:create)}
  it {should have_many(:reviews)}
  it {should have_many(:following_relationships).class_name('Relationship').with_foreign_key('follower_id')}
  it {should have_many(:leading_relationships).class_name('Relationship').with_foreign_key('leader_id')}

  it_behaves_like "tokenable" do
    let(:object) {Fabricate(:user)}
  end

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
      video       = Fabricate(:video)
      user        = Fabricate(:user)
      queue_item  = Fabricate(:queue_item, video: video, user: user)
      expect(user.queued_video?(video)).to be_truthy
    end

    it "retuns false if the video has not queue items" do
      video = Fabricate(:video)
      user  = Fabricate(:user)
      expect(user.queued_video?(video)).to be_falsy
    end
  end

  describe "#follows?" do
    it "returns true if the user follows the leader" do
      alice = Fabricate(:user)
      bob   = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(bob.follows?(alice)).to be_truthy
    end

    it "returns false if the user does not follow the leader" do
      alice = Fabricate(:user)
      bob   = Fabricate(:user)
      expect(bob.follows?(alice)).to be_falsy
    end
  end

  describe "#follow" do
    it "follows the leader" do
      alice = Fabricate(:user)
      bob   = Fabricate(:user)
      alice.follow(bob)
      expect(alice.reload.follows?(bob)).to be_truthy
    end

    it "does not follow herself" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.reload.follows?(alice)).to be_falsy
    end
  end
end