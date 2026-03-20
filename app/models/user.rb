class User < ApplicationRecord
  has_secure_password

  has_one :profile, dependent: :destroy
  has_many :workout_sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  after_create :create_default_profile!

  private

  def create_default_profile!
    create_profile!(
      goal: :hypertrophy,
      experience: :beginner,
      frequency_per_week: 3,
      unit: :kg,
      weight_step: 2.5,
      show_rpe: true,
      copy_rpe_from_previous: false,
      auto_focus_next_done: true,
      auto_start_rest_timer: true,
      continuous_add_exercises: false,
      default_rest_seconds: 90,
      available_equipment: %w[dumbbell bodyweight]
    )
  end
end
