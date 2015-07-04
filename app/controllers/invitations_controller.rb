class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge(inviter: current_user))
    if @invitation.save
      flash[:success] = "Invitation has been sent"
      @invitation.generate_token
      FlixMailer.delay.send_invitation_with_link(@invitation.id)
      redirect_to new_invitation_path
    else
      flash[:error] = "You are missing any of the fields"
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name,:recipient_email,:message)
  end
end