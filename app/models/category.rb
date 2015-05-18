class Category < ActiveRecord::Base
  has_many :videos
  validates :name, uniqueness: true
  validates :name, presence: true

  def recent_videos
    videos.reverse.take(6)
  end
end