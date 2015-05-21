require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "with user logged in" do
      it "has a @queueitems variable" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        queueitem = Fabricate(:queue_item, user: current_user)
        queueitem2 = Fabricate(:queue_item, user: current_user)
        get :index
        expect(assigns(:queue_items)).to match_array([queueitem,queueitem2])
      end
    end

    context "with no user logged in " do
      it "redirects to root path" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST create" do
    context "with user logged in" do

      let(:user) {Fabricate(:user)}
      let(:monk) {Fabricate(:video, title: "Monk")}

      before do
        session[:user_id] = user.id
      end

      it "redirects to my queue page" do
        post :create, video_id: monk.id
        expect(response).to redirect_to my_queue_path
      end

      it "creates the queue item" do
        post :create, video_id: monk.id
        expect(QueueItem.count).to eq(1)
      end

      it "does not create a record if the video is already in the queue" do
        queue_item = Fabricate(:queue_item, user: user, video: monk)
        post :create, video_id: monk.id
        expect(QueueItem.count).to be(1)
      end

      it "shows the queued item in the last position" do
        futurama = Fabricate(:video, title: "Futurama")
        queue_item = Fabricate(:queue_item, user: user, video: monk)
        post :create, video_id: futurama.id
        last_queued_item = QueueItem.where("user_id = ? and video_id = ?", user.id, futurama.id).first
        expect(last_queued_item.position).to eq(2)
      end
    end

    context "with no user logged in" do

      it "redirects to the root page" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE destroy" do
    context "with user logged in" do

      let(:user) {Fabricate(:user)}
      before {session[:user_id] = user.id}

      it "redirects to my queue path" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes de queued item from the list" do
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not delete the item if is not in the user queue" do
        alice = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: alice)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context "with no user logged in" do
      it "redirects to the root path" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST update_queue" do
    context "with user logged in" do

      let(:alice) {Fabricate(:user)}
      before { session[:user_id] = alice.id }
      
      context "with valid data" do
        it "redirects to my_queue_path" do
          queue_item = Fabricate(:queue_item, user: alice)
          post :update_queue, queue_items: [{id: queue_item.id, position: 1}]
          expect(response).to redirect_to my_queue_path
        end

        it "updates the queue items" do
          queue_item = Fabricate(:queue_item, user: alice)
          queue_item2 = Fabricate(:queue_item, user: alice)
          post :update_queue, queue_items: [{id: queue_item.id, position: 1}, {id: queue_item2.id, position: 2}]
          expect(queue_item.reload.position).to eq(1)
          expect(queue_item2.reload.position).to eq(2)
        end

        it "normalizes the items in the queue" do
          queue_item = Fabricate(:queue_item, user: alice, position: 2)
          queue_item2 = Fabricate(:queue_item, user: alice, position: 1)
          queue_item3 = Fabricate(:queue_item, user: alice, position: 3)
          post :update_queue, queue_items: [{id: queue_item.id, position: 3},{id: queue_item2.id , position: 5},
            {id: queue_item3, position: 4}]
          expect(alice.queue_items.map(&:position)).to eq([1,2,3])
        end
      end

      context "with no valid data" do
        it "redirect to my_queue_path" do
          queue_item = Fabricate(:queue_item, user: alice, position: 1)
          post :update_queue, queue_items: [{id: queue_item.id, position: 1.5}]
          expect(response).to redirect_to my_queue_path
        end

        it "shows flash error" do
          queue_item = Fabricate(:queue_item, user: alice, position: 1)
          post :update_queue, queue_items: [{id: queue_item.id, position: 1.5}]
          expect(flash[:error]).to be_present
        end

        it "does not update the data" do
          queue_item = Fabricate(:queue_item, user:alice, position: 1)
          queue_item2 = Fabricate(:queue_item, user:alice, position: 2)
          post :update_queue, queue_items: [{id: queue_item.id, position: 3} , {id: queue_item.id, position: 2.4}]
          expect(queue_item.reload.position).to eq(1)
        end
      end

      context "with user different from queue item owner"
        it "does not modify the item in the queue" do
          bob = Fabricate(:user)
          queue_item = Fabricate(:queue_item, user: bob, position: 1)
          post :update_queue, queue_items: [{id: queue_item.id, position: 2}]
          expect(queue_item.reload.position).to eq(1)
        end
    end    
    context "with no user logged in" do
      it "redirect to root path" do
        post :update_queue, queue_items: [{id: 1, position: 2}]
        expect(response).to redirect_to root_path
      end
    end
  end

end