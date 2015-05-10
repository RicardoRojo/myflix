class Video < ActiveRecord::Base
  belongs_to :category
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(string)
    return [] if string.empty?
    where("lower(title) LIKE ?", "%#{string.downcase}%").order(created_at: :asc)
  end
end