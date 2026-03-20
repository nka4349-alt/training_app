class WorkoutSession < ApplicationRecord
  belongs_to :user
  belongs_to :program_day, optional: true

  has_many :workout_exercises, dependent: :destroy
  has_many :pain_logs, dependent: :destroy

  validates :started_at, presence: true

  def duration_sec
    return nil unless finished_at
    (finished_at - started_at).to_i
  end

  def total_volume
    workout_exercises.includes(:set_entries).sum(&:total_volume)
  end
end
