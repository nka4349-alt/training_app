module WorkoutSessions
  class CreateFromProgramDay
    def self.call(user:, program_day:)
      ActiveRecord::Base.transaction do
        session = user.workout_sessions.create!(
          program_day: program_day,
          started_at: Time.current
        )

        program_day.program_day_exercises.order(:order_index).each_with_index do |pde, idx|
          ex = pde.exercise
          plan = Recommendations::InitialSetPlan.call(user: user, exercise: ex)

          we = session.workout_exercises.create!(
            exercise: ex,
            order_index: idx + 1,
            target_sets: plan[:target_sets],
            rep_range_min: plan[:rep_range_min],
            rep_range_max: plan[:rep_range_max],
            rest_seconds: plan[:rest_seconds]
          )

          plan[:set_rows].each_with_index do |set_row, i|
            we.set_entries.create!(
              set_no: i + 1,
              weight: set_row[:weight],
              reps: set_row[:reps],
              rpe: set_row[:rpe],
              status: :planned,
              rest_seconds: plan[:rest_seconds]
            )
          end
        end

        session
      end
    end
  end
end
