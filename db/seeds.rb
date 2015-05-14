# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Category.create(name: "drama")
Category.create(name: "comedy")
Category.create(name: "syfy")

number_of_records = 10

number_of_records.times do |number|
  Video.create(title: "Monk season#{number + 1}", description: "First episode from season #{number + 1}", 
    small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category: Category.all.sample )
end

number_of_users = 5

number_of_users.times do
  Fabricate(:user, password: "12345")
end

number_of_reviews = 20

number_of_reviews.times do
  Fabricate(:review, user: User.all.sample, video: Video.all.sample)
end
