class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true

      t.integer :goal, null: false, default: 0
      t.integer :experience, null: false, default: 0
      t.integer :frequency_per_week, null: false, default: 3

      t.integer :unit, null: false, default: 0
      t.decimal :weight_step, precision: 6, scale: 2, null: false, default: 2.5
      t.boolean :show_rpe, null: false, default: true

      t.string :available_equipment, array: true, default: [] # ["dumbbell","bodyweight"]
      t.timestamps
    end
  end
end