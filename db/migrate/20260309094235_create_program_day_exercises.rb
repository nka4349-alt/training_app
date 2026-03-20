class CreateProgramDayExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :program_day_exercises do |t|
      t.references :program_day, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :order_index, null: false, default: 1
      t.timestamps
    end

    add_index :program_day_exercises, [:program_day_id, :order_index]
  end
end
