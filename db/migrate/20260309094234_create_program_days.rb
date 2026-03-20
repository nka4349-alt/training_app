class CreateProgramDays < ActiveRecord::Migration[7.1]
  def change
    create_table :program_days do |t|
      t.references :program_template, null: false, foreign_key: true
      t.string :label, null: false
      t.integer :day_index, null: false
      t.string :focus_body_parts, array: true, default: []
      t.timestamps
    end
  end
end
