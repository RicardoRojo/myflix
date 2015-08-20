require 'spec_helper'

describe UserSignup do
  describe "#signup" do
    context "with valid personal information and valid card" do

      let(:alice) {Fabricate.build(:user)}
      let(:customer) {double(:customer, successful?: true, customer_token: "abcdedf")}

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(alice).signup("any_token",nil)
      end

      after do 
        ActionMailer::Base.deliveries.clear 
      end
      
      it "creates the user" do
        expect(User.count).to be(1)
      end

      it "sends the email to the right recipient with valid data" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email])
      end

      it "has valid content in the body with valid data" do
        expect(ActionMailer::Base.deliveries.last.body).to include(alice.full_name.capitalize)
      end

      it "adds stripe customer id to user" do
        expect(User.first.customer_token).to eq("abcdedf")
      end

      context "with invitation" do

        let(:bob)         {Fabricate(:user)}
        let(:charles)     {Fabricate.build(:user, email: "charles@test.com")}
        let(:invitation)  {Fabricate(:invitation, recipient_email: "charles@test.com", inviter: bob)}
        let(:customer)    {double(:customer, successful?: true, customer_token: "abcdedf")}


        before do
          StripeWrapper::Customer.should_receive(:create).and_return(customer)
          UserSignup.new(charles).signup("any_token",invitation.token)
        end

        it "the invited user follows the inviter" do
          expect(charles.reload.follows?(bob)).to be_truthy
        end

        it "the inviter user follows the invited user" do
          expect(bob.reload.follows?(charles)).to be_truthy
        end

        it "removes the token of the invitation to avoid multiple registrations with one token" do
          expect(invitation.reload.token).to be_nil
        end
      end
    end

    context "with valid personal info and declined card" do

      let(:customer) {double(:customer, successful?: false, error_message: "Your card was declined")}

      before do
        StripeWrapper::Customer.stub(:create).and_return(customer)
        user = Fabricate.build(:user)
        UserSignup.new(user).signup("fake_stripe_token",nil)
      end

      after do 
        ActionMailer::Base.deliveries.clear
      end
   
      it "does not create a record" do
        expect(User.count).to eq(0)
      end

    end

    context "with invalid personal information" do

      let(:alice)     {Fabricate.build(:user)}
      let(:customer)  {double(:customer, successful?: false, error_message: "Your card was declined")}


      before do
        UserSignup.new(User.new(email: "alice@test.com")).signup("fake_stripe_token",nil)
      end

      after do 
        ActionMailer::Base.deliveries.clear 
      end
   
      it "does not send the email if data is invalid" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it "does not create a record" do
        expect(User.count).to be(0)
      end

      it "does not try to charge the credit card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end
    end
  end
end