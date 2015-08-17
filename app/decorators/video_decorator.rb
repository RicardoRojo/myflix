class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.rating.present? ? "#{object.rating.to_f}/5" : "N/A" 
  end

end