class VideosController < ApplicationController
  before_action :require_user, except: [:search]
  before_action :redirect_to_sign_in, only: [:search]
  
  def index
    @categories = Category.includes(:videos)
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @reviews = @video.reviews
  end
  
  def search
    @videos = Video.search_by_title(params[:video])
  end

  def advanced_search
    if params[:query]
      @videos = Video.search(params[:query]).records.to_a
    else
      @videos = []
    end
  end

end