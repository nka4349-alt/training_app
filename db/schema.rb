# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_03_09_110000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercises", force: :cascade do |t|
    t.string "name", null: false
    t.string "primary_body_part", null: false
    t.string "secondary_body_parts", default: [], array: true
    t.string "equipment", default: [], array: true
    t.string "category", null: false
    t.integer "difficulty", default: 1, null: false
    t.integer "popularity_rank", default: 999, null: false
    t.jsonb "defaults_by_goal", default: {}, null: false
    t.bigint "alternative_ids", default: [], array: true
    t.string "contraindication_tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["primary_body_part", "popularity_rank"], name: "index_exercises_on_primary_body_part_and_popularity_rank"
  end

  create_table "pain_logs", force: :cascade do |t|
    t.bigint "workout_session_id", null: false
    t.string "body_part", null: false
    t.integer "severity", default: 0, null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_session_id"], name: "index_pain_logs_on_workout_session_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "goal", default: 0, null: false
    t.integer "experience", default: 0, null: false
    t.integer "frequency_per_week", default: 3, null: false
    t.integer "unit", default: 0, null: false
    t.decimal "weight_step", precision: 6, scale: 2, default: "2.5", null: false
    t.boolean "show_rpe", default: true, null: false
    t.string "available_equipment", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "copy_rpe_from_previous", default: false, null: false
    t.boolean "auto_focus_next_done", default: true, null: false
    t.boolean "auto_start_rest_timer", default: true, null: false
    t.boolean "continuous_add_exercises", default: false, null: false
    t.integer "default_rest_seconds", default: 90, null: false
    t.datetime "onboarding_completed_at"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "program_day_exercises", force: :cascade do |t|
    t.bigint "program_day_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "order_index", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_program_day_exercises_on_exercise_id"
    t.index ["program_day_id", "order_index"], name: "index_program_day_exercises_on_program_day_id_and_order_index"
    t.index ["program_day_id"], name: "index_program_day_exercises_on_program_day_id"
  end

  create_table "program_days", force: :cascade do |t|
    t.bigint "program_template_id", null: false
    t.string "label", null: false
    t.integer "day_index", null: false
    t.string "focus_body_parts", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_template_id"], name: "index_program_days_on_program_template_id"
  end

  create_table "program_templates", force: :cascade do |t|
    t.string "name", null: false
    t.string "split_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommendation_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "workout_exercise_id", null: false
    t.jsonb "input_snapshot", default: {}, null: false
    t.jsonb "output", default: {}, null: false
    t.jsonb "rationale", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_recommendation_logs_on_user_id"
    t.index ["workout_exercise_id"], name: "index_recommendation_logs_on_workout_exercise_id"
  end

  create_table "set_entries", force: :cascade do |t|
    t.bigint "workout_exercise_id", null: false
    t.integer "set_no", null: false
    t.decimal "weight", precision: 7, scale: 2
    t.integer "reps"
    t.decimal "rpe", precision: 3, scale: 1
    t.integer "status", default: 0, null: false
    t.boolean "failed", default: false, null: false
    t.integer "rest_seconds"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_exercise_id", "set_no"], name: "index_set_entries_on_workout_exercise_id_and_set_no", unique: true
    t.index ["workout_exercise_id"], name: "index_set_entries_on_workout_exercise_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workout_exercises", force: :cascade do |t|
    t.bigint "workout_session_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "order_index", default: 1, null: false
    t.integer "target_sets", default: 3, null: false
    t.integer "rep_range_min", default: 8, null: false
    t.integer "rep_range_max", default: 12, null: false
    t.integer "rest_seconds", default: 90, null: false
    t.jsonb "recommended_next", default: {}, null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_workout_exercises_on_exercise_id"
    t.index ["workout_session_id", "order_index"], name: "index_workout_exercises_on_workout_session_id_and_order_index"
    t.index ["workout_session_id"], name: "index_workout_exercises_on_workout_session_id"
  end

  create_table "workout_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "program_day_id"
    t.datetime "started_at", null: false
    t.datetime "finished_at"
    t.text "notes"
    t.jsonb "summary", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_day_id"], name: "index_workout_sessions_on_program_day_id"
    t.index ["user_id"], name: "index_workout_sessions_on_user_id"
  end

  add_foreign_key "pain_logs", "workout_sessions"
  add_foreign_key "profiles", "users"
  add_foreign_key "program_day_exercises", "exercises"
  add_foreign_key "program_day_exercises", "program_days"
  add_foreign_key "program_days", "program_templates"
  add_foreign_key "recommendation_logs", "users"
  add_foreign_key "recommendation_logs", "workout_exercises"
  add_foreign_key "set_entries", "workout_exercises"
  add_foreign_key "workout_exercises", "exercises"
  add_foreign_key "workout_exercises", "workout_sessions"
  add_foreign_key "workout_sessions", "program_days"
  add_foreign_key "workout_sessions", "users"
end
