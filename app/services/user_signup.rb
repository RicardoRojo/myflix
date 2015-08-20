class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def signup(stripe_token, invitation_token)
    if @user.valid?
      token = stripe_token
      customer = StripeWrapper::Customer.create(
        :plan => "basic", # amount in cents, again
        :source => token,
        :email => @user
      )
      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        FlixMailer.delay.send_welcome_email(@user.id)
        handle_invitation(invitation_token)
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = "User information is not correct.Please review"
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    invitation = Invitation.find_by(token: invitation_token)
    if invitation
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.remove_token!
    end
  end

  def user_params
    params.require(:user).permit(:full_name, :password, :email)
  end
end