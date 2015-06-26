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

      let(:alice) {Fabricate.build(:user)}

      it "creates the user" do
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name}
        expect(User.count).to be(1)
      end

      it "sets the session" do
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name}
        expect(session[:user_id]).to eq(User.last.id)
      end

      it "has a flash success" do
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name}
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home path" do
        post :create, user: {email: alice.email, password: alice.password, full_name: alice.full_name}
        expect(response).to redirect_to home_path
      end

      context "with invitation" do

        let(:bob)         {Fabricate(:user)}
        let(:invitation)  {Fabricate(:invitation, recipient_email: "charles@test.com", inviter: bob)}
        let(:charles)     {User.find_by(email: "charles@test.com")}

        before do
          post :create, user: { email: invitation.recipient_email, 
                                password: "12345", 
                                full_name: "charles" }, invitation_token: invitation.token
        end

        it "the invited user follows the inviter" do
          expect(charles.follows?(bob)).to be_truthy
        end

        it "the inviter user follows the invited user" do
          expect(bob.follows?(charles)).to be_truthy
        end

        it "removes the token of the invitation to avoid multiple registrations with one token" do
          expect(invitation.reload.token).to be_nil
        end
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

      before { ActionMailer::Base.deliveries.clear }

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