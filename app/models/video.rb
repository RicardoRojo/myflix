class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(string)
    return [] if string.empty?
    where("lower(title) LIKE ?", "%#{string.downcase}%").order(created_at: :asc)
  end
  
  def average_rating
    reviews.count == 0 ? 0 : (reviews.sum(:rating).to_f/reviews.count.to_f).round(1)
  end
end