module Defaults
  class ForExercise
    GLOBAL = {
      hypertrophy: {
        compound:  { sets: 3, rep_range: { min: 8,  max: 12 }, rest_seconds: 120, target_rpe: { min: 7, max: 8 } },
        isolation: { sets: 3, rep_range: { min: 10, max: 15 }, rest_seconds: 90,  target_rpe: { min: 7, max: 8 } },
        core:      { sets: 3, rep_range: { min: 10, max: 20 }, rest_seconds: 60 }
      },
      strength: {
        compound:  { sets: 5, rep_range: { min: 3,  max: 5  }, rest_seconds: 180, target_rpe: { min: 7, max: 9 } },
        isolation: { sets: 3, rep_range: { min: 6,  max: 10 }, rest_seconds: 120 },
        core:      { sets: 3, rep_range: { min: 8,  max: 15 }, rest_seconds: 60 }
      },
      fat_loss: {
        compound:  { sets: 3, rep_range: { min: 6,  max: 10 }, rest_seconds: 120 },
        isolation: { sets: 2, rep_range: { min: 10, max: 15 }, rest_seconds: 60 },
        core:      { sets: 3, rep_range: { min: 10, max: 20 }, rest_seconds: 60 }
      }
    }.freeze

    def self.call(exercise:, goal:)
      specific = exercise.defaults_for(goal)
      return specific.deep_symbolize_keys if specific.present?
      GLOBAL.fetch(goal.to_sym).fetch(exercise.category.to_sym)
    end
  end
end