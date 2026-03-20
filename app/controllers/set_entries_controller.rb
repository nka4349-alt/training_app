class SetEntriesController < ApplicationController
  def update
    @set_entry = SetEntry.find(params[:id])
    return head :forbidden unless @set_entry.workout_session.user_id == current_user.id
    return head :unprocessable_entity if @set_entry.workout_session.finished_at.present?

    prev_status = @set_entry.status
    @set_entry.update!(set_entry_params)

    if prev_status != "done" && @set_entry.done?
      @set_entry.update!(completed_at: Time.current)
    elsif prev_status == "done" && !@set_entry.done?
      @set_entry.update!(completed_at: nil)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to workout_session_path(@set_entry.workout_session), status: :see_other }
    end
  end

  private

  def set_entry_params
    params.require(:set_entry).permit(:weight, :reps, :rpe, :status, :failed)
  end
end