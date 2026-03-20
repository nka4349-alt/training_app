class CreateExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :exercises do |t|
      t.string :name, null: false

      t.string :primary_body_part, null: false
      t.string :secondary_body_parts, array: true, default: []

      t.string :equipment, array: true, default: []  # ["barbell","dumbbell"]
      t.string :category, null: false                # compound/isolation/core
      t.integer :difficulty, null: false, default: 1
      t.integer :popularity_rank, null: false, default: 999

      t.jsonb :defaults_by_goal, null: false, default: {}     # 目的別おすすめ
      t.bigint :alternative_ids, array: true, default: []     # Exercise id配列（簡易）
      t.string :contraindication_tags, array: true, default: []

      t.timestamps
    end

    add_index :exercises, [:primary_body_part, :popularity_rank]
  end
end