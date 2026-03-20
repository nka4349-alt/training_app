class SetEntry < ApplicationRecord
  belongs_to :workout_exercise

  enum status: { planned: 0, done: 1, skipped: 2 }

  validates :set_no, numericality: { greater_than: 0 }
  validates :reps, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :rpe, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 10 }, allow_nil: true

  def workout_session
    workout_exercise.workout_session
  end
end
