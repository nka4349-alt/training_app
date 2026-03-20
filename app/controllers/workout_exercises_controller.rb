class WorkoutExercisesController < ApplicationController
  before_action :set_workout_session

  def create
    return head :unprocessable_entity if @workout_session.finished_at.present?

    exercise = Exercise.find(params[:exercise_id])
    plan = Recommendations::InitialSetPlan.call(user: current_user, exercise: exercise)

    if params[:replace_workout_exercise_id].present?
      @append_mode = false
      @workout_exercise = @workout_session.workout_exercises.includes(:set_entries, :exercise).find(params[:replace_workout_exercise_id])
      rebuild_with_plan!(@workout_exercise, exercise: exercise, plan: plan)
    else
      @append_mode = true
      @workout_exercise = @workout_session.workout_exercises.create!(
        exercise: exercise,
        order_index: (@workout_session.workout_exercises.maximum(:order_index) || 0) + 1,
        target_sets: plan[:target_sets],
        rep_range_min: plan[:rep_range_min],
        rep_range_max: plan[:rep_range_max],
        rest_seconds: plan[:rest_seconds]
      )

      create_set_entries!(@workout_exercise, plan: plan)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to workout_session_path(@workout_session), status: :see_other }
    end
  end

  def add_set
    return head :unprocessable_entity if @workout_session.finished_at.present?

    @workout_exercise = @workout_session.workout_exercises.includes(:set_entries, :exercise).find(params[:id])

    last = @workout_exercise.set_entries.order(:set_no).last
    next_no = last ? last.set_no + 1 : 1

    @workout_exercise.set_entries.create!(
      set_no: next_no,
      weight: last&.weight,
      reps: last&.reps,
      rpe: current_user.profile.copy_rpe_from_previous ? last&.rpe : nil,
      status: :planned,
      rest_seconds: @workout_exercise.rest_seconds
    )

    @workout_exercise.update!(target_sets: @workout_exercise.set_entries.count)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to workout_session_path(@workout_session), status: :see_other }
    end
  end

  def restore_plan
    return head :unprocessable_entity if @workout_session.finished_at.present?

    @workout_exercise = @workout_session.workout_exercises.includes(:set_entries, :exercise).find(params[:id])
    plan = Recommendations::InitialSetPlan.call(user: current_user, exercise: @workout_exercise.exercise)
    rebuild_with_plan!(@workout_exercise, exercise: @workout_exercise.exercise, plan: plan)

    respond_to do |format|
      format.turbo_stream { render :add_set }
      format.html { redirect_to workout_session_path(@workout_session), status: :see_other }
    end
  end

  def apply_first_weight
    return head :unprocessable_entity if @workout_session.finished_at.present?

    @workout_exercise = @workout_session.workout_exercises.includes(:set_entries, :exercise).find(params[:id])
    first_set = @workout_exercise.set_entries.order(:set_no).first

    if first_set&.weight.present?
      @workout_exercise.set_entries.where.not(id: first_set.id).update_all(weight: first_set.weight, updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
    end

    @workout_exercise.reload

    respond_to do |format|
      format.turbo_stream { render :add_set }
      format.html { redirect_to workout_session_path(@workout_session), status: :see_other }
    end
  end

  def destroy
    workout_session = @workout_session
    we = workout_session.workout_exercises.find(params[:id])
    we.destroy!
    redirect_to workout_session_path(workout_session), status: :see_other
  end

  private

  def set_workout_session
    @workout_session = current_user.workout_sessions.find(params[:workout_session_id])
  end

  def rebuild_with_plan!(workout_exercise, exercise:, plan:)
    workout_exercise.transaction do
      workout_exercise.update!(
        exercise: exercise,
        target_sets: plan[:target_sets],
        rep_range_min: plan[:rep_range_min],
        rep_range_max: plan[:rep_range_max],
        rest_seconds: plan[:rest_seconds]
      )

      workout_exercise.set_entries.delete_all
      create_set_entries!(workout_exercise, plan: plan)
    end
  end

  def create_set_entries!(workout_exercise, plan:)
    plan[:set_rows].each_with_index do |set_row, idx|
      workout_exercise.set_entries.create!(
        set_no: idx + 1,
        weight: set_row[:weight],
        reps: set_row[:reps],
        rpe: set_row[:rpe],
        status: :planned,
        rest_seconds: plan[:rest_seconds]
      )
    end
  end
end
