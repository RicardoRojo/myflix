class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :category
  has_many :queue_items
  has_many :reviews, -> {order "created_at DESC"}
  validates :title, presence: true
  validates :description, presence: true

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end

  def self.search_by_title(string)
    return [] if string.empty?
    where("lower(title) LIKE ?", "%#{string.downcase}%").order(created_at: :asc)
  end

  def as_indexed_json(options = {})
    self.as_json(
      only: [:title, :description],
      include: {
        reviews: { only: [:body] }
      }
    )
  end

  def self.search(query, options = {})
    search_definition =
      {
        query: {
          multi_match: {
            query: query,
            fields: ["title^100", "description^50"],
            operator: "and"
          }
        }
      }

    if query.present? && options[:reviews]
      search_definition[:query][:multi_match][:fields] << "reviews.body"
    end

    __elasticsearch__.search(search_definition)
  end
end
