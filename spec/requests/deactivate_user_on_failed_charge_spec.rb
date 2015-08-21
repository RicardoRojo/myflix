require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id"=> "evt_16c2NrEEmXoFagV2IcZnLuiC",
      "created"=> 1440113027,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_16c2NrEEmXoFagV2vaTDXlIw",
          "object"=> "charge",
          "created"=> 1440113027,
          "livemode"=> false,
          "paid"=> false,
          "status"=> "failed",
          "amount"=> 999,
          "currency"=> "eur",
          "refunded"=> false,
          "source"=> {
            "id"=> "card_16c2KiEEmXoFagV2DN0Ldj90",
            "object"=> "card",
            "last4"=> "0341",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 8,
            "exp_year"=> 2016,
            "fingerprint"=> "7756PH9B7IkOF79s",
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
            "customer"=> "cus_6pggrIv2I30dmx"
          },
          "captured"=> false,
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_6pggrIv2I30dmx",
          "invoice"=> nil,
          "description"=> "fail paymentttt",
          "dispute"=> nil,
          "metadata"=> {},
          "statement_descriptor"=> nil,
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
            "url"=> "/v1/charges/ch_16c2NrEEmXoFagV2vaTDXlIw/refunds",
            "data"=> []
          }
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "req_6phnkzQCqd4g78",
      "api_version"=> "2015-07-13"
    }
  end
 
  it "Deactivates a user with web hook from stripe failed charge", :vcr do
    alice = Fabricate(:user, customer_token: "cus_6pggrIv2I30dmx", active: true)
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end