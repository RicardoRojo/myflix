Fabricator(:user) do
  full_name {Faker::Name.name}
  email {Faker::Internet.email}
  password {Faker::Internet.password(5)}
end