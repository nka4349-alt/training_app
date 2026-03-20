class CreateRecommendationLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendation_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workout_exercise, null: false, foreign_key: true

      t.jsonb :input_snapshot, null: false, default: {}
      t.jsonb :output, null: false, default: {}
      t.jsonb :rationale, null: false, default: []

      t.timestamps
    end
  end
end