class AdminsController < AuthenticatedController
  before_action :require_admin

  private

  def require_admin
    if !current_user.admin?
      flash[:error] = "User not allowed to do that"
      redirect_to home_path
    end
  end
end