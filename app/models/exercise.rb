class Exercise < ApplicationRecord
  BODY_PARTS = %w[chest back legs shoulders biceps triceps core full].freeze
  CATEGORIES = %w[compound isolation core].freeze

  BODY_PART_LABELS = {
    "chest" => "胸", "back" => "背中", "legs" => "脚", "shoulders" => "肩",
    "biceps" => "二頭", "triceps" => "三頭", "core" => "体幹", "full" => "全身"
  }.freeze

  has_many :program_day_exercises, dependent: :restrict_with_exception
  has_many :workout_exercises, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :primary_body_part, inclusion: { in: BODY_PARTS }
  validates :category, inclusion: { in: CATEGORIES }

  def defaults_for(goal)
    defaults_by_goal[goal.to_s].presence
  end

  def body_part_label
    BODY_PART_LABELS[primary_body_part] || primary_body_part
  end
end
