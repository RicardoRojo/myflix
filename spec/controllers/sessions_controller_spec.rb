require 'spec_helper'

describe SessionsController do
  
  let(:user) {Fabricate(:user)}

  describe "GET new" do

    it "redirects to home page if logged in" do
      session[:user_id] = user.id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do

    context "with valid credentials" do

      before do
        post :create, email: user.email, password: user.password
      end

      it "sets user id session" do
        expect(session[:user_id]).to be(user.id)
      end

      it "shows a success flash message" do
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end

    end

    context "with invalid credentials" do

      before do
        post :create, email: user.email, password: "fake password"
      end

      it "does not set session" do
        expect(session[:user_id]).to be_nil
      end

      it "shows danger flash message" do
        expect(flash.now[:danger]).not_to be_blank
      end

      it "renders new template" do
        expect(response).to render_template :new
      end

    end
  end

  describe "GET destroy" do

    context "with user logged in" do

      before do
        session[:user_id] = user.id
        get :destroy
      end

      it "destroys session" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "with user not logged in" do
      it "redirects to root path" do
        session[:user_id] = nil
        get :destroy
        expect(response).to redirect_to root_path
      end
    end
  end
end