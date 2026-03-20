class ProgramDay < ApplicationRecord
  belongs_to :program_template
  has_many :program_day_exercises, dependent: :destroy
  has_many :exercises, through: :program_day_exercises

  validates :label, presence: true
end
