class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: "video"
  delegate :reviews, to: :video

  validates :position, numericality: {only_integer: true}
  
  def category_name
    category.name
  end

  def rating
    reviews.first.rating if reviews.first
  end

  def rating=(new_rating)
    review = reviews.find_by(user: user)
    if review
      review.update_attribute(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

end
