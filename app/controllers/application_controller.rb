class ApplicationController < ActionController::Base
  before_action :gon_current_user

  check_authorization unless :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    format.html { redirect_to root_url, alert: exception.message }
    format.json { render json: exception.message, status: :unprocessable_entity }
  end

  private

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
