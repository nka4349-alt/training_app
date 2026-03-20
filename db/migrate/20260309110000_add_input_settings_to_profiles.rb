class AddInputSettingsToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :copy_rpe_from_previous, :boolean, default: false, null: false
    add_column :profiles, :auto_focus_next_done, :boolean, default: true, null: false
    add_column :profiles, :auto_start_rest_timer, :boolean, default: true, null: false
    add_column :profiles, :continuous_add_exercises, :boolean, default: false, null: false
    add_column :profiles, :default_rest_seconds, :integer, default: 90, null: false
    add_column :profiles, :onboarding_completed_at, :datetime
  end
end
