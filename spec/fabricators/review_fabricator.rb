Fabricator(:review) do
  video {Fabricate(:video)}
  user {Fabricate(:user)}
  rating {[1,2,3,4,5].sample}
  body {Faker::Lorem.paragraph}
end