class User < ActiveRecord::Base
  has_many :videos
  has_many :queue_items, -> {order "position ASC"}
  has_secure_password validations: false
  validates :full_name, presence: true
  validates :email, presence: true, email: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 5}, on: :create

  def normalize_queue_item_list
    queue_items.each_with_index do |item,index|
      item.update_attributes(position: index+1)
    end    
  end
end