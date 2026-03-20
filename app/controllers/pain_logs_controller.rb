class PainLogsController < ApplicationController
  before_action :set_workout_session

  def create
    pain_log = @workout_session.pain_logs.find_or_initialize_by(body_part: pain_log_params[:body_part])
    pain_log.assign_attributes(pain_log_params)
    pain_log.save!
    render_panel
  end

  def update
    pain_log = @workout_session.pain_logs.find(params[:id])
    pain_log.update!(pain_log_params)
    render_panel
  end

  def destroy
    pain_log = @workout_session.pain_logs.find(params[:id])
    pain_log.destroy!
    render_panel
  end

  private

  def set_workout_session
    @workout_session = current_user.workout_sessions.find(params[:workout_session_id])
  end

  def pain_log_params
    params.require(:pain_log).permit(:body_part, :severity, :note)
  end

  def render_panel
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "pain_panel",
          partial: "workout_sessions/pain_panel",
          locals: { workout_session: @workout_session }
        )
      end
      format.html { redirect_to workout_session_path(@workout_session), status: :see_other }
    end
  end
end
