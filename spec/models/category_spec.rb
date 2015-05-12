require 'spec_helper'

describe Category do
  it {should have_many(:videos)}

  it {should validate_uniqueness_of(:name)}

  describe "#recent_videos" do

    it "returns an empty array if no videos found" do
      category = Category.create(name: "syfy")
      expect(category.recent_videos).to eq([])
    end

    it "returns an array of one if only found one video" do
      category = Category.create(name: "syfy")
      stargate = Video.create(title: "stargate", description: "stargate video", category: Category.find_by(name: "syfy"))
      expect(category.recent_videos).to eq([stargate])
    end

    it "must return 6 videos at most" do
      category = Category.create(name: "syfy")
      stargate_seasons = 7
      stargate_seasons.times do |season|
        stargate = Video.create(title: "stargate season #{season + 1}", description: "video from season #{season + 1}", 
          category: Category.find_by(name: "syfy"))
      end
      expect(category.recent_videos.count).to eq(6)
    end

    it "must be ordered by created_at ascending(last video first)" do
      category = Category.create(name: "syfy")
      stargate_seasons = 7
      seasons_array = []
      stargate_seasons.times do |season|
        stargate = Video.create(title: "stargate season #{season + 1}", description: "video from season #{season + 1}", 
          category: category)
        seasons_array << stargate
      end
      expect(category.recent_videos).to eq(seasons_array.reverse.take(6))
    end
  end
end