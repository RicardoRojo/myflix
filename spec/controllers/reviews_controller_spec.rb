require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated user" do

      let(:current_user) {Fabricate(:user)}
      before {session[:user_id] = current_user.id}
      context "with valid input" do

        it "redirects to the video path" do
          video = Fabricate(:video)
          post :create, review: {rating: 3, body: "this is a review"}, video_id: video.id
          expect(response).to redirect_to video
        end

        it "creates the review" do
          video = Fabricate(:video)
          post :create, review: {rating: 4, body: "this is a test"}, video_id: video.id
          expect(Review.count).to eq(1)
        end

        it "is associated to a video" do
          video = Fabricate(:video)
          post :create, review: {rating: 4, body: "this is a test"}, video_id: video.id
          expect(Review.first.video).to eq(video)
        end

        it "is associated with the user who created it" do
          video = Fabricate(:video)
          post :create, review: {rating: 4, body: "this is a test"}, video_id: video.id
          expect(Review.first.user).to eq(current_user)
        end

        it "has to be ordered. Last review first" do
          video = Fabricate(:video)
          review1 = Fabricate(:review, video: video)
          post :create, review: {rating: 4, body: "this is a test"}, video_id: video.id
          expect(video.reviews.first).not_to eq(review1)
        end

      end

      context "with invalid input" do

        it "does not create the user" do
          video = Fabricate(:video)
          post :create, review: {body: "this is a test"}, video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "renders 'videos/show' action" do
          video = Fabricate(:video)
          post :create, review: {body: "this is a test"}, video_id: video.id
          expect(response).to render_template "videos/show"
        end

        it "has valid @video" do 
          video = Fabricate(:video)
          post :create, review: {body: "this is a test"}, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "has valid @reviews" do
          video = Fabricate(:video)
          review = Fabricate(:review,video: video)
          post :create, review: {body: "this is a test"}, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "with unauthenticated user" do
      it "redirects to sign_in path" do
        video = Fabricate(:video)
        post :create, review: {body: "this is a test"}, video_id: video.id
        expect(response).to redirect_to root_path
      end
    end

  end
end