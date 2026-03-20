class WorkoutSessionsController < ApplicationController
  def create
    program_day = ProgramDay.find(params[:program_day_id])
    session = WorkoutSessions::CreateFromProgramDay.call(user: current_user, program_day: program_day)
    redirect_to workout_session_path(session), status: :see_other
  end

  def show
    @workout_session = current_user.workout_sessions
      .includes(:pain_logs, workout_exercises: [:exercise, :set_entries])
      .find(params[:id])
  end

  def finish
    @workout_session = current_user.workout_sessions.find(params[:id])
    return redirect_to workout_session_path(@workout_session), status: :see_other if @workout_session.finished_at.present?

    WorkoutSessions::Finish.call(user: current_user, session: @workout_session)
    redirect_to workout_session_path(@workout_session), status: :see_other
  end
end
