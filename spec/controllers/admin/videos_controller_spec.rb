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
end