class CreateWorkoutSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :workout_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :program_day, null: true, foreign_key: true

      t.datetime :started_at, null: false
      t.datetime :finished_at
      t.text :notes
      t.jsonb :summary, null: false, default: {}

      t.timestamps
    end
  end
end