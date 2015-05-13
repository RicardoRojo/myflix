require 'spec_helper'

describe UsersController do

  describe "GET new" do

    before do
      user = Fabricate(:user)
      session[:user_id] = user.id
      get :new
    end

    it "redirects to home if logged in" do
      expect(response).to redirect_to home_path
    end
    
    it "assigns a new variable to user and is an instance of user" do
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do

    context "with valid information" do

      before do
        user = Fabricate.build(:user)
        post :create, user: {email: user.email, password: user.password, full_name: user.full_name}
      end

      it "creates the user" do
        expect(User.count).to be(1)
      end

      it "sets the session" do
        expect(session[:user_id]).to eq(User.last.id)
      end

      it "has a flash success" do
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end

    end
    context "with invalid information" do

      before do
        user = Fabricate.build(:user)
        post :create, user: {password: user.password, full_name: user.full_name}
      end

      it "does not create a record" do
        expect(User.count).to be(0)
      end

      it "does not set session" do
        expect(session[:user_id]).to be_blank
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end
    end
  end
end