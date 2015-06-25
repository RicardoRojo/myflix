class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  validates :recipient_name, presence: true
  validates :recipient_email, presence: true
  validates :message, presence: true

  def generate_token
    update_attribute(:token, SecureRandom.urlsafe_base64)
  end
end