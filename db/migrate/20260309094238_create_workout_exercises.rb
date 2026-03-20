class CreateWorkoutExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :workout_exercises do |t|
      t.references :workout_session, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true

      t.integer :order_index, null: false, default: 1

      t.integer :target_sets, null: false, default: 3
      t.integer :rep_range_min, null: false, default: 8
      t.integer :rep_range_max, null: false, default: 12
      t.integer :rest_seconds, null: false, default: 90

      t.jsonb :recommended_next, null: false, default: {}
      t.text :note
      t.timestamps
    end

    add_index :workout_exercises, [:workout_session_id, :order_index]
  end
end