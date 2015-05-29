require 'spec_helper'

describe VideosController do

  describe "GET show" do

    it_behaves_like "require user" do
      let(:action) { get :show, id: 1}
    end

    context "authenticated user" do

      let(:my_video) {Fabricate(:video)}

      before do
        set_user(Fabricate(:user))
      end

      it "sets @video" do
        get :show, id: my_video.id
        expect(assigns(:video)).to eq(my_video)
      end

      it "sets @reviews" do
        review1 = Fabricate(:review, video: my_video)
        review2 = Fabricate(:review, video: my_video)
        get :show, id: my_video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end

    end
  end

  describe "GET search" do

    it_behaves_like "redirect to sign in" do
      let(:action) {get :search, video_title: "test"}
    end

    context "authenticated user" do 

      before do
        set_user(Fabricate(:user))
      end

      it "is assigned @videos" do
        my_video = Fabricate(:video)
        get :search, video_title: my_video.title.downcase.first(3)
        expect(assigns(:videos)).to include(my_video)
      end
    end
  end
end