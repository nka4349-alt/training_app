class ProfilesController < ApplicationController
  def edit
    @profile = current_user.profile
    @onboarding = params[:onboarding] == "1" || !@profile.onboarded?
  end

  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      @profile.update!(onboarding_completed_at: Time.current) if params[:complete_onboarding] == "1"
      redirect_to(params[:complete_onboarding] == "1" ? root_path : settings_path, status: :see_other)
    else
      @onboarding = params[:onboarding] == "1" || !@profile.onboarded?
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    permitted = params.require(:profile).permit(
      :goal,
      :experience,
      :frequency_per_week,
      :unit,
      :weight_step,
      :show_rpe,
      :copy_rpe_from_previous,
      :auto_focus_next_done,
      :auto_start_rest_timer,
      :continuous_add_exercises,
      :default_rest_seconds,
      available_equipment: []
    )
    permitted[:available_equipment] = Array(permitted[:available_equipment]).reject(&:blank?)
    permitted
  end
end
