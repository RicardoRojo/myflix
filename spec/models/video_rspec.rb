require 'spec_helper'

describe Video do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should belong_to(:category) }

  describe "#search_by_title" do
    it "should return an empty array if the search is an empty string" do
      star_trek = Video.create(title: "star trek", description: "Live long and prosper")
      stargate = Video.create(title: "stargate", description: "Travel to the stars")
      expect(Video.search_by_title("")).to eq([])
    end
    it "should return an empty array if no records found" do
      star_trek = Video.create(title: "star trek", description: "Live long and prosper")
      stargate = Video.create(title: "stargate", description: "Travel to the stars")
      expect(Video.search_by_title("matrix")).to eq([])
    end
    it "should return an array of one element if the query returns one and only one result" do
      star_trek = Video.create(title: "star trek", description: "Live long and prosper")
      stargate = Video.create(title: "stargate", description: "Travel to the stars")
      expect(Video.search_by_title("stargate")).to eq([stargate])
    end
    it "should return an array of coincident records if no exact match" do
      star_trek = Video.create(title: "star trek", description: "Live long and prosper")
      stargate = Video.create(title: "stargate", description: "Travel to the stars")
      expect(Video.search_by_title("star")).to eq([star_trek, stargate])
    end
    it "should return an array of records ordered by created_at if multiple records are found " do
      star_trek = Video.create(title: "star trek", description: "Live long and prosper")
      stargate = Video.create(title: "stargate", description: "Travel to the stars", created_at: 1.day.ago)
      expect(Video.search_by_title("star")).to eq([stargate,star_trek])
    end
  end
end