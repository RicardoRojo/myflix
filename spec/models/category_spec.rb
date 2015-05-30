require 'spec_helper'

describe Category do
  it {should have_many(:videos)}
  it {should validate_uniqueness_of(:name)}
  it {should validate_presence_of(:name)}

  describe "#recent_videos" do

    let(:category) {Fabricate(:category)}

    it "returns an empty array if no videos found" do
      expect(category.recent_videos).to eq([])
    end

    it "returns an array of one if only found one video" do
      stargate = Fabricate(:video, category: category)
      expect(category.recent_videos).to eq([stargate])
    end

    it "must return 6 videos at most" do
      Fabricate.times(7,:video, category: category)
      expect(category.recent_videos.count).to eq(6)
    end

    it "must be ordered by created_at ascending(last video first)" do
      monk        = Fabricate(:video, category: category)
      south_park  = Fabricate(:video, category: category)
      futurama    = Fabricate(:video, category: category)
     
      expect(category.recent_videos).to eq [futurama,south_park,monk]
    end
  end
end