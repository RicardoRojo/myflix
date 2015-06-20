module ApplicationHelper
  def options_for_select_with_stars(default_value)
    options_for_select([5,4,3,2,1].map {|rating| [pluralize(rating, "Star"), rating]}, default_value)
  end

  def user_gravatar(user)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=40"
  end
end
