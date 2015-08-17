require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do

      it "creates a charge", :vcr do
        cardNumber = "4242424242424242"
        token = Stripe::Token.create(
                      :card => {
                        :number => cardNumber,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Charge.create(amount: 999, currency: "eur", source: token, description: "test charge")
        expect(response).to be_successful
      end

      it "creates a card denied " , :vcr do
        cardNumber = "4000000000000002"
        token = Stripe::Token.create(
                      :card => {
                        :number => cardNumber,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Charge.create(amount: 999, currency: "eur", source: token, description: "test charge")
        expect(response).not_to be_successful
      end

      it "returns the error message for card declined", vcr: true do
        cardNumber = "4000000000000002"
        token = Stripe::Token.create(
                      :card => {
                        :number => cardNumber,
                        :exp_month => 7,
                        :exp_year => 2016,
                        :cvc => "314"}
                    ).id
        response = StripeWrapper::Charge.create(amount: 999, currency: "eur", source: token, description: "test charge")
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end