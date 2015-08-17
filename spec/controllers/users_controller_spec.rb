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

    context "successful user signup" do

      let(:alice) {Fabricate.build(:user)}

      before do
        result = double(successful?: true)
        UserSignup.any_instance.should_receive(:signup).and_return(result)
      end
      
      it "sets the session" do
        user = double("user")
        id = double("id")
        user.stub(:id).and_return(id)
        User.stub(:last).and_return(user)
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name,id: 1}
        expect(session[:user_id]).to eq(1)
      end

      it "has a flash success" do
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name}
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home path" do
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name}
        expect(response).to redirect_to home_path
      end

    end

    context "with unsuccesful user login" do

      let(:charge) {double(:charge, successful?: false, error_message: "Your card was declined")}

      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
        user = Fabricate.build(:user)
        post :create, user: {email: user.email, password: user.password, full_name: user.full_name}, stripeToken: "12345"
      end

      it "shows a flash message" do
        expect(flash[:error]).to be_present
      end

      it "does not set session" do
        expect(session[:user_id]).to be_blank
      end

      it "renders new template" do
        expect(response).to render_template(:new)
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

  describe "GET new_with_token" do
    context "with valid token" do

      let(:invitation) {Fabricate(:invitation)}
      before { get :new_with_token, token: invitation.token }

      it "renders template new" do
        expect(response).to render_template :new
      end

      it "assigns @user" do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_instance_of User
      end

      it "sets the recipient name in the form" do
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end

      it "saves the recipient token" do
        expect(assigns(:invitation_token)).to eq(invitation.token)
      end
    end

    context "with invalid token" do
      it "redirects to invalid token path" do
        get :new_with_token, token: "abcdef12345"
        expect(response).to redirect_to expired_token_path
      end

      it "redirects to invalid token path if token is blank" do
        get :new_with_token, token: ""
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end