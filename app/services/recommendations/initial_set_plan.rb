module Recommendations
  class InitialSetPlan
    def self.call(user:, exercise:)
      profile = user.profile
      defaults = Defaults::ForExercise.call(exercise: exercise, goal: profile.goal)
      rep_min = defaults.dig(:rep_range, :min)
      rep_max = defaults.dig(:rep_range, :max)

      last_workout_exercise = WorkoutExercise
        .joins(:workout_session)
        .where(workout_sessions: { user_id: user.id })
        .where(exercise_id: exercise.id)
        .where.not(workout_sessions: { finished_at: nil })
        .order("workout_sessions.finished_at DESC")
        .includes(:set_entries)
        .first

      base_plan = InitialPlan.call(
        user: user,
        exercise: exercise,
        rep_range_min: rep_min,
        rep_range_max: rep_max
      )

      rows_from_history = build_history_rows(
        last_workout_exercise: last_workout_exercise,
        copy_rpe: profile.copy_rpe_from_previous
      )

      rows_from_recommended_next = build_recommended_rows(
        last_workout_exercise: last_workout_exercise,
        history_rows: rows_from_history,
        defaults: defaults,
        rep_min: rep_min,
        rep_max: rep_max,
        fallback_weight: base_plan[:weight],
        fallback_reps: base_plan[:reps_target]
      )

      if rows_from_recommended_next.present?
        return {
          source: :recommended_next,
          target_sets: rows_from_recommended_next.size,
          rep_range_min: last_workout_exercise.rep_range_min.presence || rep_min,
          rep_range_max: last_workout_exercise.rep_range_max.presence || rep_max,
          rest_seconds: last_workout_exercise.rest_seconds.presence || defaults[:rest_seconds] || profile.default_rest_seconds,
          set_rows: rows_from_recommended_next
        }
      end

      if rows_from_history.present?
        return {
          source: :history,
          target_sets: rows_from_history.size,
          rep_range_min: last_workout_exercise.rep_range_min.presence || rep_min,
          rep_range_max: last_workout_exercise.rep_range_max.presence || rep_max,
          rest_seconds: last_workout_exercise.rest_seconds.presence || defaults[:rest_seconds] || profile.default_rest_seconds,
          set_rows: rows_from_history
        }
      end

      target_sets = defaults[:sets]
      set_rows = Array.new(target_sets) do
        { weight: base_plan[:weight], reps: base_plan[:reps_target], rpe: nil }
      end

      {
        source: :default,
        target_sets: target_sets,
        rep_range_min: rep_min,
        rep_range_max: rep_max,
        rest_seconds: defaults[:rest_seconds] || profile.default_rest_seconds,
        set_rows: set_rows
      }
    end

    def self.build_recommended_rows(last_workout_exercise:, history_rows:, defaults:, rep_min:, rep_max:, fallback_weight:, fallback_reps:)
      return [] unless last_workout_exercise

      recommended_next = last_workout_exercise.recommended_next.presence || {}
      return [] if recommended_next.blank?

      target_sets = normalize_positive_int(recommended_next["sets"]) ||
        last_workout_exercise.target_sets.presence ||
        defaults[:sets] ||
        history_rows.size

      return [] unless target_sets.to_i.positive?

      reps_target = normalize_positive_int(recommended_next["reps_target"]) ||
        fallback_reps ||
        midpoint_reps(
          last_workout_exercise.rep_range_min.presence || rep_min,
          last_workout_exercise.rep_range_max.presence || rep_max
        )

      weight = if recommended_next["weight"].present?
        recommended_next["weight"].to_f
      elsif history_rows.first.present?
        history_rows.first[:weight]
      else
        fallback_weight
      end

      Array.new(target_sets) do |idx|
        {
          weight: weight,
          reps: reps_target,
          rpe: history_rows[idx]&.dig(:rpe)
        }
      end
    end

    def self.build_history_rows(last_workout_exercise:, copy_rpe:)
      return [] unless last_workout_exercise

      source_sets = last_workout_exercise.set_entries.select(&:done?).sort_by(&:set_no)
      source_sets = last_workout_exercise.set_entries.sort_by(&:set_no) if source_sets.empty?
      return [] if source_sets.empty?

      source_sets.map do |set_entry|
        {
          weight: set_entry.weight&.to_f,
          reps: set_entry.reps,
          rpe: copy_rpe ? set_entry.rpe : nil
        }
      end
    end

    def self.normalize_positive_int(value)
      int_value = value.to_i
      int_value if int_value.positive?
    end

    def self.midpoint_reps(rep_min, rep_max)
      ((rep_min.to_i + rep_max.to_i) / 2.0).round
    end
  end
end
