class PainLog < ApplicationRecord
  belongs_to :workout_session
  enum severity: { light: 0, moderate: 1, severe: 2 }
end
