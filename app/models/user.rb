class User < ActiveRecord::Base
  has_many :videos
  has_many :queue_items
  has_secure_password validations: false
  validates :full_name, presence: true
  validates :email, presence: true, email: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 5}, on: :create
end