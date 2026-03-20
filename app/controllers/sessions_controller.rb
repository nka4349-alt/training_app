class SessionsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      if user.profile.onboarded?
        redirect_to root_path, status: :see_other
      else
        redirect_to edit_profile_path(onboarding: 1), status: :see_other
      end
    else
      flash.now[:alert] = "メールアドレスかパスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, status: :see_other
  end
end
