class CreateProgramTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :program_templates do |t|
      t.string :name, null: false
      t.string :split_type, null: false
      t.timestamps
    end
  end
end
