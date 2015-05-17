require 'spec_helper'

describe VideosController do

  describe "GET show" do
    context "authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "sets @video" do

        my_video = Fabricate(:video)
        get :show, id: my_video.id
        expect(assigns(:video)).to eq(my_video)
      end
    end

    context "unauthenticated user" do

      it "redirects to root path" do
        get :show, id: 1
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET search" do

    context "authenticated user" do 
      before do
        session[:user_id] = Fabricate(:user).id
      end
      it "is assigned @videos" do

        my_video = Fabricate(:video)

        get :search, video_title: my_video.title.downcase.first(3)

        expect(assigns(:videos)).to include(my_video)
      end
    end

    context "unauthenticated user" do

      it "redirects to sign_in path" do
        get :search, video_title: "test"
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end