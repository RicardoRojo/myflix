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

  def destroy
    queue_item = QueueItem.find(params[:id])
    remove_item_from_queue(queue_item)
    redirect_to my_queue_path
  end

  private

  def add_item_to_queue(video)
    QueueItem.create!(video: video, user: current_user, position: current_user.queue_items.count + 1)
  end

  def item_is_already_queued?(video)
    !!QueueItem.find_by(video: video, user: current_user)
  end

  def remove_item_from_queue(queue_item)
    queue_item.destroy if current_user.queue_items.include?(queue_item)
  end
end