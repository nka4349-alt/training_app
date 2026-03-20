class ProgramDayExercise < ApplicationRecord
  belongs_to :program_day
  belongs_to :exercise
  validates :order_index, numericality: { greater_than: 0 }
end
