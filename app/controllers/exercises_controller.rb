class ExercisesController < ApplicationController
  def picker
    @workout_session = current_user.workout_sessions.find(params[:workout_session_id])
    @body_parts = Exercise::BODY_PARTS
    @replace_workout_exercise_id = params[:replace_workout_exercise_id]
    render layout: false
  end

  def index
    @workout_session = current_user.workout_sessions.find(params[:workout_session_id])
    body_part = params[:body_part]
    @replace_workout_exercise_id = params[:replace_workout_exercise_id]
    @selected_equipment = params[:equipment].presence
    @selected_difficulty = params[:difficulty].presence&.to_i

    base = Exercise.where(primary_body_part: body_part)
    base = base.where("? = ANY (equipment)", @selected_equipment) if @selected_equipment
    base = base.where(difficulty: @selected_difficulty) if @selected_difficulty.present?

    @equipment_filters = Exercise.where(primary_body_part: body_part).pluck(:equipment).flatten.uniq.sort
    @exercises = ranked_exercises(base: base)

    render layout: false
  end

  private

  def ranked_exercises(base:)
    allowed_equipment = current_user.profile.available_equipment
    goal = current_user.profile.goal
    pain_body_parts = @workout_session.pain_logs
      .where(severity: [PainLog.severities[:moderate], PainLog.severities[:severe]])
      .pluck(:body_part)

    recent_ids = WorkoutExercise
      .joins(:workout_session)
      .where(workout_sessions: { user_id: current_user.id })
      .where.not(workout_sessions: { finished_at: nil })
      .order("workout_sessions.finished_at DESC")
      .limit(30)
      .pluck(:exercise_id)
    recent_counts = recent_ids.tally

    base.to_a.sort_by do |exercise|
      score = exercise.popularity_rank.to_i
      score += 24 unless (exercise.equipment & allowed_equipment).any?
      score += 10 if goal == "strength" && exercise.category != "compound"
      score += 6 if goal == "fat_loss" && exercise.category == "compound" && exercise.difficulty.to_i >= 3
      score += 60 if (exercise.contraindication_tags & pain_body_parts).any?
      score -= [recent_counts[exercise.id].to_i, 4].min * 4
      [score, exercise.popularity_rank.to_i]
    end
  end
end
