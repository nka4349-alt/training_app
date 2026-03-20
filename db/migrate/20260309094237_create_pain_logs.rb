class CreatePainLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :pain_logs do |t|
      t.references :workout_session, null: false, foreign_key: true
      t.string :body_part, null: false
      t.integer :severity, null: false, default: 0
      t.text :note
      t.timestamps
    end
  end
end