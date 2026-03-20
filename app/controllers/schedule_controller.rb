class ScheduleController < ApplicationController
  def show
    @profile = current_user.profile
    @template = ProgramTemplate.includes(:program_days).first
    @program_days = @template ? @template.program_days.order(:day_index).to_a : []
    @next_week = build_next_week
  end

  private

  def build_next_week
    today = Time.zone.today
    return [] if @program_days.empty?

    (0..6).map do |offset|
      date = today + offset
      program_day = @program_days[offset % @program_days.size]
      { date: date, program_day: program_day }
    end
  end
end
