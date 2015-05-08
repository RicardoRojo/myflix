class VideosController < ApplicationController
  def index
    @categories = Category.includes(:videos).all
  end
  def show
    @video = Video.find(params[:id])
  end
  def search
    @videos = Video.search_by_title(params[:video_title])
  end
end