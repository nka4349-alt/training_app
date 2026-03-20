class CreateUsers < ActiveRecord::Migration[7.1] # ←ここは生成された数字のまま
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
