require 'spec_helper'

describe "create payment on successful charge", :vcr do

  let(:event_data) do
    {
      "id"=> "evt_16bwHbEEmXoFagV2JMvJ9DO1",
      "created"=> 1440089575,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_16bwHbEEmXoFagV2jCCc4GG3",
          "object"=> "charge",
          "created"=> 1440089575,
          "livemode"=> false,
          "paid"=> true,
          "status"=> "succeeded",
          "amount"=> 999,
          "currency"=> "eur",
          "refunded"=> false,
          "source"=> {
            "id"=> "card_16bwHYEEmXoFagV2PApOylWt",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 8,
            "exp_year"=> 2016,
            "fingerprint"=> "j3yuCLZD8rGsbXsr",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "tokenization_method"=> nil,
            "dynamic_last4"=> nil,
            "metadata"=> {},
            "customer"=> "cus_6pbUirBiejEuoo"
          },
          "captured"=> true,
          "balance_transaction"=> "txn_16bwHbEEmXoFagV24NZ4hJm1",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_6pbUirBiejEuoo",
          "invoice"=> "in_16bwHbEEmXoFagV2dsYkuQ7b",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {},
          "statement_descriptor"=> "Basic Plan",
          "fraud_details"=> {},
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil,
          "destination"=> nil,
          "application_fee"=> nil,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_16bwHbEEmXoFagV2jCCc4GG3/refunds",
            "data"=> []
          }
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "req_6pbUdKg0NwwZ4R",
      "api_version"=> "2015-07-13"
    }
  end

  it "creates a payment with successful webhook from stripe from charge succeeded"  do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user" do
    alice = Fabricate(:user, customer_token: "cus_6pbUirBiejEuoo" )
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount" do
    alice = Fabricate(:user, customer_token: "cus_6pbUirBiejEuoo" )
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with the reference to the invoice" do
    alice = Fabricate(:user, customer_token: "cus_6pbUirBiejEuoo" )
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_16bwHbEEmXoFagV2jCCc4GG3")
  end
end