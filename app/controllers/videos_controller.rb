class VideosController < ApplicationController
  before_action :require_user, except: [:search]
  before_action :redirect_to_sign_in, only: [:search]
  
  def index
    @categories = Category.includes(:videos)
  end

  def show
    @video = Video.find(params[:id])
  end
  
  def search
    @videos = Video.search_by_title(params[:video_title])
  end

end