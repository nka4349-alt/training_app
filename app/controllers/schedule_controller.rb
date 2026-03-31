class ScheduleController < ApplicationController
  WORKOUT_DAY_PATTERNS = {
    2 => [0, 3],
    3 => [0, 2, 4],
    4 => [0, 1, 3, 5],
    5 => [0, 1, 3, 4, 6],
    6 => [0, 1, 2, 4, 5, 6]
  }.freeze

  def show
    @profile = current_user.profile
    @template = ProgramTemplate.includes(:program_days).find_by(name: "PPL")
    @program_days = @template ? @template.program_days.order(:day_index).to_a : []
    @next_week = build_next_week
  end

  private

  def build_next_week
    today = Time.zone.today
    return [] if @program_days.empty?

    workout_offsets = WORKOUT_DAY_PATTERNS.fetch(@profile.frequency_per_week, WORKOUT_DAY_PATTERNS[3])
    workout_index = 0

    (0..6).map do |offset|
      date = today + offset

      if workout_offsets.include?(offset)
        program_day = @program_days[workout_index % @program_days.size]
        workout_index += 1
        { date: date, program_day: program_day, rest_day: false }
      else
        { date: date, program_day: nil, rest_day: true }
      end
    end
  end
end
