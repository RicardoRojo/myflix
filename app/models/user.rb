class User < ActiveRecord::Base
  has_many :videos
  has_many :queue_items, -> {order "position"}
  has_secure_password validations: false
  validates :full_name, presence: true
  validates :email, presence: true, email: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 5}, on: :create
  has_many :reviews
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  def normalize_queue_item_list
    queue_items.each_with_index do |item,index|
      item.update_attributes(position: index+1)
    end    
  end

  def queued_video?(video)
    queue_items.find_by(video: video)
  end

  def already_followed?(leader)
    following_relationships.map(&:leader).include?(leader)
  end

  def has_role?(role)
    self == role
  end

  def not_followable?(user)
    already_followed?(user) || has_role?(user)
  end
end