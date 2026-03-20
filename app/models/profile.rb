class Profile < ApplicationRecord
  belongs_to :user

  enum goal: { hypertrophy: 0, strength: 1, fat_loss: 2 }
  enum experience: { beginner: 0, intermediate: 1, advanced: 2 }
  enum unit: { kg: 0, lb: 1 }

  validates :frequency_per_week, inclusion: { in: 2..6 }
  validates :weight_step, numericality: { greater_than: 0 }
  validates :default_rest_seconds, numericality: { greater_than: 0 }

  def onboarded?
    onboarding_completed_at.present?
  end
end
