require 'spec_helper'

describe UsersController do

  describe "GET new" do

    it "redirects to home if logged in" do
      user = Fabricate(:user)
      set_user(user)
      get :new
      expect(response).to redirect_to home_path
    end
    
    it "assigns a new variable to user and is an instance of user" do
      get :new
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

    context "test mailer" do
      let(:alice) {Fabricate.build(:user)}

      after { ActionMailer::Base.deliveries.clear }

      it "sends the email to the right recipient with valid data" do
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name}
        expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email])
      end

      it "has valid content in the body with valid data" do
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name}
        expect(ActionMailer::Base.deliveries.last.body).to include(alice.full_name.capitalize)
      end

      it "does not send the email if data is invalid" do
        post :create, user: {email: alice.email}
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require user" do
      let(:action) {get :show, id: 1}
    end

    context "with user signed in" do
      it "assigns the @user variable" do
        alice = Fabricate(:user)
        set_user(alice)
        get :show, id: alice
        expect(assigns(:user)).to eq(alice)
      end
    end
  end
end