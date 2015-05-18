require 'spec_helper'

describe QueueItemsController do
  it "has a @queueitems variable" do
    current_user = Fabricate(:user)
    session[:user_id] = current_user.id
    queueitem = Fabricate(:queue_item, user: current_user)
    queueitem2 = Fabricate(:queue_item, user: current_user)
    get :index
    expect(assigns(:queue_items)).to eq([queueitem,queueitem2])
  end

  it "redirects to root path if no user" do
    get :index
    expect(response).to redirect_to root_path
  end
end