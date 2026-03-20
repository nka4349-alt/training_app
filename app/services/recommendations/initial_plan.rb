module Recommendations
  class InitialPlan
    def self.call(user:, exercise:, rep_range_min:, rep_range_max:)
      profile = user.profile
      reps_target = ((rep_range_min + rep_range_max) / 2.0).round

      last_we = WorkoutExercise
        .joins(:workout_session)
        .where(workout_sessions: { user_id: user.id })
        .where(exercise_id: exercise.id)
        .where.not(workout_sessions: { finished_at: nil })
        .order("workout_sessions.finished_at DESC")
        .first

      weight =
        if last_we&.recommended_next.present? && last_we.recommended_next["weight"].present?
          last_we.recommended_next["weight"].to_f
        else
          last_weight = last_we&.set_entries&.select(&:done?)&.map(&:weight)&.compact&.first
          last_weight || StarterWeight.call(profile: profile, exercise: exercise)
        end

      { weight: weight, reps_target: reps_target }
    end
  end
end