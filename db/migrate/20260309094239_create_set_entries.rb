class CreateSetEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :set_entries do |t|
      t.references :workout_exercise, null: false, foreign_key: true

      t.integer :set_no, null: false
      t.decimal :weight, precision: 7, scale: 2
      t.integer :reps
      t.decimal :rpe, precision: 3, scale: 1

      t.integer :status, null: false, default: 0  # planned/done/skipped
      t.boolean :failed, null: false, default: false

      t.integer :rest_seconds
      t.datetime :completed_at
      t.timestamps
    end

    add_index :set_entries, [:workout_exercise_id, :set_no], unique: true
  end
end