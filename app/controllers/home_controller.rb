class HomeController < ApplicationController
  def show
    unless current_user.profile.onboarded?
      return redirect_to edit_profile_path(onboarding: 1)
    end

    @ongoing_session = current_user.workout_sessions.where(finished_at: nil).order(started_at: :desc).first
    @templates = ProgramTemplate.includes(program_days: { program_day_exercises: :exercise }).all
    @weekly_completed = current_user.workout_sessions
      .where.not(finished_at: nil)
      .where("finished_at >= ?", 7.days.ago)
      .count

    done_sets = SetEntry
      .joins(workout_exercise: [:exercise, :workout_session])
      .includes(workout_exercise: :exercise)
      .where(workout_sessions: { user_id: current_user.id })
      .where.not(workout_sessions: { finished_at: nil })
      .where(status: SetEntry.statuses[:done])
      .where("set_entries.weight > 0")

    @best_weights = done_sets
      .group_by { |set_entry| set_entry.workout_exercise.exercise.name }
      .map do |exercise_name, entries|
        best_entry = entries.max_by { |entry| entry.weight.to_f }
        [exercise_name, best_entry.weight.to_f, best_entry.reps.to_i]
      end
      .sort_by { |_name, weight, _reps| -weight }
      .first(3)
  end
end
