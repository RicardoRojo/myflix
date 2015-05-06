require 'spec_helper'

describe Category do
  it "should create record and save it" do
    category = Category.new(name: "drama")
    category.save
    expect(Category.first.name).to eq("drama")
  end
  it "should create record and verify relation with Video table" do
    category = Category.new(name: "drama", videos: [Video.create(title: "Death on the nile", description: "a good movie")])
    category.save
    expect(Category.first.videos.first.title).to eq("Death on the nile")
  end
end