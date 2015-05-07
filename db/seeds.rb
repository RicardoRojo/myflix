# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
number_of_records = 10

number_of_records.times do |number|
  Video.create(title: "Monk season#{number + 1}", description: "First episode from season #{number + 1}", 
    small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg" )
end