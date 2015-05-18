class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])

    add_item_to_queue(video) unless item_is_already_queued?(video)
    redirect_to my_queue_path
  end

  private

  def add_item_to_queue(video)
    QueueItem.create!(video_id: params[:video_id], user: current_user, position: current_user.queue_items.count + 1)
  end

  def item_is_already_queued?(video)
    !!QueueItem.where("video_id = ? and user_id = ?", params[:video_id], current_user.id).first
  end
end