require 'spec_helper'

describe User do
  it {should validate_presence_of(:full_name)}
  
  it {should validate_presence_of(:email)}

  it {should validate_uniqueness_of(:email)}

  it "has to validate email is not correct" do
    user = User.create(full_name: "Bruce Banner", password: "Smash", email: "hulk@test")
    expect(user.errors.messages.any?).to eq(true)
  end

  it "validates email is correct" do
    user = User.create(full_name: "Bruce Banner", password: "Smash", email: "hulk@test.com")
    expect(user.errors.messages.any?).to eq(false)
  end

  it {should validate_presence_of(:password)}

  it "has to validate minimum lenght of password" do
    should validate_length_of(:password).
    is_at_least(5).
    on(:create)
  end

end