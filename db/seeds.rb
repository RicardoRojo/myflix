# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Category.create!(name: "drama")
Category.create!(name: "comedy")
Category.create!(name: "syfy")

number_of_records = 10

number_of_records.times do |number|
  Video.create!(title: "Monk season#{number + 1}", description: "First episode from season #{number + 1}", 
    small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category: Category.all.sample )
end

Fabricate.times(5,:user,password: "12345")
User.create!(full_name: "Administrator", email: "admin@myflix.com", password: "12345")

number_of_reviews = 20

Fabricate.times(20, :review, user: User.all.sample, video: Video.all.sample)