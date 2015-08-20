require 'spec_helper'

describe StripeWrapper do
  let(:valid_card) {"4242424242424242"}
  let(:declined_card) {"4000000000000002"}

  describe StripeWrapper::Charge do
    describe ".create" do

      it "creates a charge", :vcr do
        token = Stripe::Token.create(
                      :card => {
                        :number => valid_card,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Charge.create(amount: 999, currency: "eur", source: token, description: "test charge")
        expect(response).to be_successful
      end

      it "creates a card denied " , :vcr do
        token = Stripe::Token.create(
                      :card => {
                        :number => declined_card,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Charge.create(amount: 999, currency: "eur", source: token, description: "test charge")
        expect(response).not_to be_successful
      end

      it "returns the error message for card declined", vcr: true do
        token = Stripe::Token.create(
                      :card => {
                        :number => declined_card,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Charge.create(amount: 999, currency: "eur", source: token, description: "test charge")
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create", :vcr do
      it "creates a Customer with valid card" do
        alice = Fabricate(:user)
        token = Stripe::Token.create(
                      :card => {
                        :number => valid_card,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Customer.create(source: token,plan: "basic",email: alice )
        expect(response).to be_successful
      end

      it "does not create a Customer with declined card" do
        alice = Fabricate(:user)
        token = Stripe::Token.create(
                      :card => {
                        :number => declined_card,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Customer.create(source: token,plan: "basic",email: alice )
        expect(response).not_to be_successful
      end

      it "returns the error message for card declined", vcr: true do
        alice = Fabricate(:user)
        token = Stripe::Token.create(
                      :card => {
                        :number => declined_card,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Customer.create(source: token,plan: "basic",email: alice)
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end