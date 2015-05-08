class Category < ActiveRecord::Base
  has_many :videos
  validates :name, uniqueness: true

  def recent_videos
    videos.reverse.take(6)
  end
end