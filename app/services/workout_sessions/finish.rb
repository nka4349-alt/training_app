module WorkoutSessions
  class Finish
    def self.call(user:, session:)
      ActiveRecord::Base.transaction do
        session.update!(finished_at: Time.current)
        session.update!(summary: { duration_sec: session.duration_sec, total_volume: session.total_volume })

        session.workout_exercises.includes(:set_entries).each do |we|
          rec = Recommendations::RuleBasedNext.call(user: user, workout_exercise: we)

          we.update!(
            recommended_next: {
              weight: rec[:weight],
              reps_target: rec[:reps_target],
              sets: rec[:sets],
              rationale: rec[:rationale]
            }
          )

          RecommendationLog.create!(
            user: user,
            workout_exercise: we,
            input_snapshot: {
              rep_min: we.rep_range_min,
              rep_max: we.rep_range_max,
              done_sets: we.set_entries.select(&:done?).map { |s|
                { weight: s.weight, reps: s.reps, rpe: s.rpe, failed: s.failed }
              }
            },
            output: { weight: rec[:weight], reps_target: rec[:reps_target], sets: rec[:sets] },
            rationale: rec[:rationale]
          )
        end

        session
      end
    end
  end
end