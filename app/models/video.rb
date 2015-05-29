class Video < ActiveRecord::Base
  belongs_to :category
  has_many :queue_items
  has_many :reviews, -> {order "created_at DESC"}
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(string)
    return [] if string.empty?
    where("lower(title) LIKE ?", "%#{string.downcase}%").order(created_at: :asc)
  end

end