require 'spec_helper'

describe Video do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should belong_to(:category) }
  it { should have_many(:queue_items) }

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

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars1 = Fabricate(:video, title: "Star Wars: Episode I")
        star_wars2 = Fabricate(:video, title: "Star Wars: Episode II")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index
        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars1, star_wars2]
      end
    end

    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, body: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, body: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end
  end
end
