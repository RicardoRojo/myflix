require 'spec_helper'

describe Video do
  it "saves data" do
    video = Video.new(title: "Death on the nile",
      description: "As Hercule Poirot enjoys a luxurious cruise down the Nile, a newlywed heiress is found murdered on board.",
      small_cover_url: "tmp/monk.jpg",
      large_cover_url: "tmp/monk_large.jpg")
    video.save
    expect(Video.first.title).to eq("Death on the nile")
  end
  it "creates record and verify relation" do
    video = Video.new(title: "Death on the nile",
      description: "As Hercule Poirot enjoys a luxurious cruise down the Nile, a newlywed heiress is found murdered on board.",
      small_cover_url: "tmp/monk.jpg",
      large_cover_url: "tmp/monk_large.jpg",
      category: Category.create(name: "drama"))
    video.save
    expect(Video.first.category.name).to eq("drama")
  end
end