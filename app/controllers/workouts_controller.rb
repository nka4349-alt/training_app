class WorkoutsController < ApplicationController
  def show
    @ongoing_session = current_user.workout_sessions.where(finished_at: nil).order(started_at: :desc).first
    return redirect_to workout_session_path(@ongoing_session) if @ongoing_session

    @templates = ProgramTemplate.includes(program_days: { program_day_exercises: :exercise }).all
  end
end
