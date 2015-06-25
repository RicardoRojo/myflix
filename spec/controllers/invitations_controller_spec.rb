require "spec_helper"

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "require user" do
      let(:action) {get :new}
    end

    it "assigns @invitation" do
      set_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe "POST create" do
    it_behaves_like "require user" do
      let(:action) { post :create }
    end

    context "with valid information" do

      before do
        set_user
        post :create, invitation: { recipient_name: "alice", 
                                    recipient_email: "alice@test.com",
                                    message: "join myflix, its great!!" }
      end

      it "redirects to new" do
        expect(response).to redirect_to new_invitation_path
      end

      it "creates a new invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "shows a succesful message" do
        expect(flash[:success]).to eq("Invitation has been sent")
      end

      it "sends a message" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["alice@test.com"])
      end

      it "generates a token" do
        expect(Invitation.last.token).not_to be_blank
      end
    end

    context "with invalid information" do

      before do
        ActionMailer::Base.deliveries.clear
        set_user
        post :create, invitation: { recipient_name: "alice", message: "join myflix, its great!!" }
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "shows a message" do
        expect(flash[:error]).to eq("You are missing any of the fields")
      end

      it "does not send a message" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it "assigns @invitation" do
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end
