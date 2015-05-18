require 'spec_helper'

describe Video do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should belong_to(:category) }
  it { should have_many(:queue_items)}

  describe ".search_by_title" do
    let(:star_trek) {Fabricate(:video, title: "star trek")}
    let(:stargate) {Fabricate(:video, title: "stargate",created_at: 1.day.ago)}

    it "returns an empty array if the search is an empty string" do
      expect(Video.search_by_title("")).to eq([])
    end

    it "returns an empty array if no records found" do
      expect(Video.search_by_title("matrix")).to eq([])
    end

    it "returns an array of one element if the query returns one and only one result" do
      expect(Video.search_by_title("stargate")).to eq([stargate])
    end

    it "returns an array of coincident records if no exact match" do
      expect(Video.search_by_title("star")).to match_array([star_trek, stargate])
    end
    
    it "returns an array of records ordered by created_at if multiple records are found " do
      expect(Video.search_by_title("star")).to eq([stargate,star_trek])
    end
  end
end