class ProgressController < ApplicationController
  def show
    @recent_sessions = current_user.workout_sessions
      .where.not(finished_at: nil)
      .order(finished_at: :desc)
      .limit(10)
      .includes(workout_exercises: [:exercise, :set_entries])

    @weekly_volume = current_user.workout_sessions
      .where.not(finished_at: nil)
      .where("finished_at >= ?", 12.weeks.ago)
      .includes(workout_exercises: :set_entries)
      .group_by { |session| session.finished_at.to_date.strftime("%Y-W%V") }
      .map { |week, grouped| [week, grouped.sum(&:total_volume)] }
      .sort_by(&:first)

    done_sets_scope = SetEntry
      .joins(workout_exercise: [:exercise, :workout_session])
      .includes(workout_exercise: [:exercise, :workout_session])
      .where(workout_sessions: { user_id: current_user.id })
      .where.not(workout_sessions: { finished_at: nil })
      .where(status: SetEntry.statuses[:done])
      .where("set_entries.weight > 0")

    exercise_counts = done_sets_scope
      .group("exercises.id", "exercises.name")
      .count

    @exercise_options = exercise_counts
      .sort_by { |(exercise_id, exercise_name), count| [-count, exercise_name] }
      .map { |(exercise_id, exercise_name), _count| [exercise_name, exercise_id] }

    @selected_exercise_id = params[:exercise_id].presence&.to_i || @exercise_options.first&.last
    @selected_exercise = Exercise.find_by(id: @selected_exercise_id)

    @max_weight_points =
      if @selected_exercise
        done_sets_scope
          .where(exercises: { id: @selected_exercise.id })
          .to_a
          .group_by { |set_entry| set_entry.workout_session }
          .map do |session, entries|
            [session.finished_at.to_date, entries.map { |entry| entry.weight.to_f }.max.to_f]
          end
          .sort_by(&:first)
          .last(10)
      else
        []
      end
  end
end
