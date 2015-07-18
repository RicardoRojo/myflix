require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do

    it_behaves_like "require user" do
      let(:action) {get :new}
    end

    it "assigns @new" do
      set_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it "redirect to home path if not admin" do
      set_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "shows flash error if not admin" do
      set_user
      get :new
      expect(flash[:error]).to be_present
    end

  end

  describe "POST create" do

    it_behaves_like "require admin" do
      let(:action) {post :create}
    end

    context "with valid information" do

      let(:category) {Fabricate(:category)}

      before do 
        category = Fabricate(:category)
        set_admin
        post :create, video: {title: "test title", description: "test title description", category: category.id}
      end

      it "redirects to new_admin_video" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a video" do
        expect(Video.count).to eq(1)
      end

      it "shows a success flash message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid information" do

      before do
        set_admin
        post :create, video: {title: "test title"}
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end

      it "does not create a video" do
        expect(Video.count).to eq(0)
      end

      it "assigns @video" do
        expect(assigns(:video)).to be_present
      end

      it "shows flash error" do
        expect(flash[:error]).to be_present
      end
    end
  end
end