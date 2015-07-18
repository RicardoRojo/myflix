class AddVideoUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :video_url, :text
  end
end
