class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: "video"
  delegate :reviews, to: :video
  
  def category_name
    category.name
  end

  def rating
    reviews.first.rating if reviews.first
  end

end
