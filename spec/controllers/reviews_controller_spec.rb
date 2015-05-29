require 'spec_helper'

describe ReviewsController do
  describe "POST create" do

    it_behaves_like "require user" do
      let(:action) {post :create, review: {rating: 4, body: "this is a review"}, video_id: 1}
    end

    context "with authenticated user" do

      let(:alice) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}

      before do
        set_user(alice)
      end

      context "with valid input" do

        before { post :create, review: {rating: 4, body: "this is a test"}, video_id: video.id}

        it "redirects to the video path" do
          expect(response).to redirect_to video
        end

        it "creates the review" do
          expect(Review.count).to eq(1)
        end

        it "is associated to a video" do
          expect(Review.first.video).to eq(video)
        end

        it "is associated with the user who created it" do
          expect(Review.first.user).to eq(alice)
        end

        it "has to be ordered. Last review first" do
          review1 = Fabricate(:review, video: video)
          expect(video.reviews.first).to eq(review1)
        end

      end

      context "with invalid input" do

        it "does not create the review" do
          post :create, review: {body: "this is a test"}, video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "renders 'videos/show' action" do
          post :create, review: {body: "this is a test"}, video_id: video.id
          expect(response).to render_template "videos/show"
        end

        it "has valid @video" do 
          post :create, review: {body: "this is a test"}, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "has valid @reviews" do
          review = Fabricate(:review,video: video)
          post :create, review: {body: "this is a test"}, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end
  end
end