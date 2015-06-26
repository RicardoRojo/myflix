require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do

    let(:alice) {Fabricate(:user, token: "12345")}

    it "render show template with valid token" do
      get :show, id: alice.token
      expect(response).to render_template(:show)
    end

    it "assign @token" do
      get :show, id: alice.token
      expect(assigns(:token)).to eq("12345")
    end

    it "redirects to invalid token page with invalid token" do
      get :show, id: '11111'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do

      let(:alice) {Fabricate(:user, password: "12345", token: "12345")}
      before {post :create, password: "new_password", token: alice.token}

      it "with valid token it redirects to sign_in path" do
        expect(response).to redirect_to sign_in_path
      end

      it "resets the password" do
        expect(alice.reload.authenticate("new_password")).to be_truthy
      end

      it "shows message" do
        expect(flash[:success]).to eq("Congratulations, you changed your password.")
      end

      it "deletes user token" do
        expect(alice.reload.token).to be_nil
      end

    end

    context "with invalid token" do
      it "redirect to root path if token is empty" do
        post :create, password: "12345", token: ""
        expect(response).to redirect_to root_path
      end

      it "redirect to root path if token is empty" do
        post :create, password: "12345", token: "1111"
        expect(response).to redirect_to expired_token_path
      end
    end

    context "with invalid password" do

      let(:alice) {Fabricate(:user, password: "12345", token: "12345")}
      before {post :create, password: "", token: alice.token}

      it "renders show template" do
        expect(response).to render_template(:show)
      end

      it "shows an error message" do
        expect(flash[:error]).to eq("Wrong password. Try again!!")
      end

      it "does not update the password" do
        alice_old_password = alice.password
        expect(alice.reload.password).to eq(alice_old_password)
      end

      it "assigns @token for show template" do
        expect(assigns(:token)).to eq(alice.token)
      end
    end
  end
end