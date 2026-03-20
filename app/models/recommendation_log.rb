class RecommendationLog < ApplicationRecord
  belongs_to :user
  belongs_to :workout_exercise
end
