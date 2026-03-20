class ApplicationController < ActionController::Base
  helper_method :current_user

  before_action :require_login

  private

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = session[:user_id] && User.find_by(id: session[:user_id])
  end

  def require_login
    return if current_user
    redirect_to new_session_path
  end
end
