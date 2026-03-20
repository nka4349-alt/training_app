class WorkoutExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise
  has_many :set_entries, dependent: :destroy

  validates :target_sets, numericality: { greater_than: 0 }

  def done_sets
    set_entries.select(&:done?)
  end

  def total_volume
    done_sets.sum { |s| (s.weight || 0).to_f * (s.reps || 0).to_i }
  end
end
