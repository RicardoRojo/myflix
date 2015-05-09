class User < ActiveRecord::Base
  has_secure_password
  validates :full_name, presence: true
  validates :email, presence: true, email: true, uniqueness: true
  # validates :password, presence: true -- Removed, bcrypt-ruby forces it. test passed
  validates :password,length: {minimum: 5},on: :create
end