require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank email" do

      before {post :create, email: ""}

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        expect(flash[:error]).to eq("Email cant be blank")
      end
    end

    context "with valid email" do

      let(:alice) {alice = Fabricate(:user)}
      before {post :create, email: alice.email}

      it "redirects to forgot password confirmation page" do
        expect(response).to redirect_to confirm_password_reset_path
      end

      it "creates a token for the user" do
        expect(alice.reload.token).not_to be_blank
      end

      it "sends an email to the email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email])
      end
    end

    context "with invalid email" do

      before {post :create, email: "wrongmail@test.com"}

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        expect(flash[:error]).to eq("Your email is not in our database. Maybe you misspelled it?")
      end
    end
  end
end