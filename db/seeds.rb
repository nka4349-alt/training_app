DEFAULTS_BY_GOAL = {
  hypertrophy: {
    "compound" => { sets: 3, rep_range: { min: 8, max: 12 }, rest_seconds: 120 },
    "isolation" => { sets: 3, rep_range: { min: 10, max: 15 }, rest_seconds: 75 },
    "core" => { sets: 3, rep_range: { min: 10, max: 20 }, rest_seconds: 60 }
  },
  strength: {
    "compound" => { sets: 5, rep_range: { min: 3, max: 5 }, rest_seconds: 180 },
    "isolation" => { sets: 3, rep_range: { min: 6, max: 10 }, rest_seconds: 105 },
    "core" => { sets: 3, rep_range: { min: 8, max: 15 }, rest_seconds: 75 }
  },
  fat_loss: {
    "compound" => { sets: 3, rep_range: { min: 6, max: 10 }, rest_seconds: 120 },
    "isolation" => { sets: 2, rep_range: { min: 10, max: 15 }, rest_seconds: 60 },
    "core" => { sets: 3, rep_range: { min: 10, max: 20 }, rest_seconds: 60 }
  }
}.freeze

def defaults_for(category)
  {
    hypertrophy: DEFAULTS_BY_GOAL[:hypertrophy][category],
    strength: DEFAULTS_BY_GOAL[:strength][category],
    fat_loss: DEFAULTS_BY_GOAL[:fat_loss][category]
  }
end

def upsert_exercise(attrs)
  exercise = Exercise.find_or_initialize_by(name: attrs[:name])
  exercise.assign_attributes(attrs)
  exercise.defaults_by_goal = defaults_for(attrs[:category])
  exercise.save!
  exercise
end

exercise_master = [
  { name: "ベンチプレス", primary_body_part: "chest", secondary_body_parts: %w[shoulders triceps], equipment: %w[barbell], category: "compound", difficulty: 2, popularity_rank: 1, contraindication_tags: %w[shoulders] },
  { name: "ダンベルベンチプレス", primary_body_part: "chest", secondary_body_parts: %w[shoulders triceps], equipment: %w[dumbbell], category: "compound", difficulty: 1, popularity_rank: 2, contraindication_tags: %w[shoulders] },
  { name: "インクラインベンチプレス", primary_body_part: "chest", secondary_body_parts: %w[shoulders triceps], equipment: %w[barbell dumbbell], category: "compound", difficulty: 2, popularity_rank: 3, contraindication_tags: %w[shoulders] },
  { name: "プッシュアップ", primary_body_part: "chest", secondary_body_parts: %w[triceps core], equipment: %w[bodyweight], category: "compound", difficulty: 1, popularity_rank: 4, contraindication_tags: [] },
  { name: "ケーブルフライ", primary_body_part: "chest", secondary_body_parts: %w[shoulders], equipment: %w[cable], category: "isolation", difficulty: 1, popularity_rank: 5, contraindication_tags: %w[shoulders] },
  { name: "ペックフライ", primary_body_part: "chest", secondary_body_parts: %w[shoulders], equipment: %w[machine], category: "isolation", difficulty: 1, popularity_rank: 6, contraindication_tags: %w[shoulders] },

  { name: "懸垂", primary_body_part: "back", secondary_body_parts: %w[biceps], equipment: %w[bodyweight], category: "compound", difficulty: 2, popularity_rank: 1, contraindication_tags: %w[shoulders] },
  { name: "ラットプルダウン", primary_body_part: "back", secondary_body_parts: %w[biceps], equipment: %w[machine cable], category: "compound", difficulty: 1, popularity_rank: 2, contraindication_tags: [] },
  { name: "バーベルロー", primary_body_part: "back", secondary_body_parts: %w[biceps], equipment: %w[barbell], category: "compound", difficulty: 2, popularity_rank: 3, contraindication_tags: %w[lower_back] },
  { name: "シーテッドロー", primary_body_part: "back", secondary_body_parts: %w[biceps], equipment: %w[machine cable], category: "compound", difficulty: 1, popularity_rank: 4, contraindication_tags: [] },
  { name: "ワンハンドダンベルロー", primary_body_part: "back", secondary_body_parts: %w[biceps], equipment: %w[dumbbell], category: "compound", difficulty: 1, popularity_rank: 5, contraindication_tags: [] },
  { name: "デッドリフト", primary_body_part: "back", secondary_body_parts: %w[legs core], equipment: %w[barbell], category: "compound", difficulty: 3, popularity_rank: 6, contraindication_tags: %w[lower_back] },

  { name: "スクワット", primary_body_part: "legs", secondary_body_parts: %w[core], equipment: %w[barbell], category: "compound", difficulty: 2, popularity_rank: 1, contraindication_tags: %w[knees lower_back] },
  { name: "レッグプレス", primary_body_part: "legs", secondary_body_parts: %w[core], equipment: %w[machine], category: "compound", difficulty: 1, popularity_rank: 2, contraindication_tags: %w[knees] },
  { name: "ルーマニアンデッドリフト", primary_body_part: "legs", secondary_body_parts: %w[back], equipment: %w[barbell dumbbell], category: "compound", difficulty: 2, popularity_rank: 3, contraindication_tags: %w[lower_back] },
  { name: "ブルガリアンスクワット", primary_body_part: "legs", secondary_body_parts: %w[core], equipment: %w[dumbbell bodyweight], category: "compound", difficulty: 2, popularity_rank: 4, contraindication_tags: %w[knees] },
  { name: "レッグエクステンション", primary_body_part: "legs", secondary_body_parts: %w[], equipment: %w[machine], category: "isolation", difficulty: 1, popularity_rank: 5, contraindication_tags: %w[knees] },
  { name: "レッグカール", primary_body_part: "legs", secondary_body_parts: %w[], equipment: %w[machine], category: "isolation", difficulty: 1, popularity_rank: 6, contraindication_tags: [] },
  { name: "カーフレイズ", primary_body_part: "legs", secondary_body_parts: %w[], equipment: %w[bodyweight machine], category: "isolation", difficulty: 1, popularity_rank: 7, contraindication_tags: %w[ankle] },

  { name: "ショルダープレス", primary_body_part: "shoulders", secondary_body_parts: %w[triceps], equipment: %w[dumbbell machine], category: "compound", difficulty: 2, popularity_rank: 1, contraindication_tags: %w[shoulders] },
  { name: "サイドレイズ", primary_body_part: "shoulders", secondary_body_parts: %w[], equipment: %w[dumbbell], category: "isolation", difficulty: 1, popularity_rank: 2, contraindication_tags: %w[shoulders] },
  { name: "リアレイズ", primary_body_part: "shoulders", secondary_body_parts: %w[back], equipment: %w[dumbbell], category: "isolation", difficulty: 1, popularity_rank: 3, contraindication_tags: [] },
  { name: "フェイスプル", primary_body_part: "shoulders", secondary_body_parts: %w[back], equipment: %w[cable], category: "isolation", difficulty: 1, popularity_rank: 4, contraindication_tags: [] },
  { name: "アーノルドプレス", primary_body_part: "shoulders", secondary_body_parts: %w[triceps], equipment: %w[dumbbell], category: "compound", difficulty: 2, popularity_rank: 5, contraindication_tags: %w[shoulders] },

  { name: "ダンベルカール", primary_body_part: "biceps", secondary_body_parts: %w[], equipment: %w[dumbbell], category: "isolation", difficulty: 1, popularity_rank: 1, contraindication_tags: [] },
  { name: "ハンマーカール", primary_body_part: "biceps", secondary_body_parts: %w[], equipment: %w[dumbbell], category: "isolation", difficulty: 1, popularity_rank: 2, contraindication_tags: [] },
  { name: "プリチャーカール", primary_body_part: "biceps", secondary_body_parts: %w[], equipment: %w[machine], category: "isolation", difficulty: 2, popularity_rank: 3, contraindication_tags: [] },

  { name: "プレスダウン", primary_body_part: "triceps", secondary_body_parts: %w[], equipment: %w[cable], category: "isolation", difficulty: 1, popularity_rank: 1, contraindication_tags: [] },
  { name: "ディップス", primary_body_part: "triceps", secondary_body_parts: %w[chest], equipment: %w[bodyweight], category: "compound", difficulty: 2, popularity_rank: 2, contraindication_tags: %w[shoulders] },
  { name: "フレンチプレス", primary_body_part: "triceps", secondary_body_parts: %w[], equipment: %w[dumbbell], category: "isolation", difficulty: 2, popularity_rank: 3, contraindication_tags: %w[elbow] },

  { name: "プランク", primary_body_part: "core", secondary_body_parts: %w[], equipment: %w[bodyweight], category: "core", difficulty: 1, popularity_rank: 1, contraindication_tags: [] },
  { name: "ハンギングレッグレイズ", primary_body_part: "core", secondary_body_parts: %w[hip], equipment: %w[bodyweight], category: "core", difficulty: 2, popularity_rank: 2, contraindication_tags: %w[lower_back] },
  { name: "クランチ", primary_body_part: "core", secondary_body_parts: %w[], equipment: %w[bodyweight], category: "core", difficulty: 1, popularity_rank: 3, contraindication_tags: [] },
  { name: "アブローラー", primary_body_part: "core", secondary_body_parts: %w[shoulders], equipment: %w[bodyweight], category: "core", difficulty: 2, popularity_rank: 4, contraindication_tags: %w[lower_back shoulders] }
].freeze

exercises = exercise_master.map { |attributes| upsert_exercise(attributes) }

ppl = ProgramTemplate.find_or_create_by!(name: "PPL") { |template| template.split_type = "ppl" }
ppl.update!(split_type: "ppl")

full_body = ProgramTemplate.find_or_create_by!(name: "全身3日") { |template| template.split_type = "full_body" }
full_body.update!(split_type: "full_body")

push = ppl.program_days.find_or_create_by!(label: "Push", day_index: 1)
push.update!(focus_body_parts: %w[chest shoulders triceps])
pull = ppl.program_days.find_or_create_by!(label: "Pull", day_index: 2)
pull.update!(focus_body_parts: %w[back biceps])
legs = ppl.program_days.find_or_create_by!(label: "Legs", day_index: 3)
legs.update!(focus_body_parts: %w[legs core])

full_a = full_body.program_days.find_or_create_by!(label: "Full A", day_index: 1)
full_a.update!(focus_body_parts: %w[chest back legs])
full_b = full_body.program_days.find_or_create_by!(label: "Full B", day_index: 2)
full_b.update!(focus_body_parts: %w[shoulders legs core])
full_c = full_body.program_days.find_or_create_by!(label: "Full C", day_index: 3)
full_c.update!(focus_body_parts: %w[chest back core])

program_map = {
  push => ["ベンチプレス", "インクラインベンチプレス", "ショルダープレス", "プレスダウン", "ダンベルベンチプレス", "サイドレイズ", "ディップス"],
  pull => ["ラットプルダウン", "シーテッドロー", "ダンベルカール", "ハンマーカール", "懸垂", "ワンハンドダンベルロー", "フェイスプル"],
  legs => ["スクワット", "ルーマニアンデッドリフト", "レッグプレス", "カーフレイズ", "ブルガリアンスクワット", "レッグエクステンション", "レッグカール"],
  full_a => ["ベンチプレス", "シーテッドロー", "スクワット", "プランク"],
  full_b => ["ショルダープレス", "ブルガリアンスクワット", "レッグカール", "クランチ"],
  full_c => ["ダンベルベンチプレス", "ワンハンドダンベルロー", "レッグエクステンション", "ハンギングレッグレイズ"]
}

program_map.each do |program_day, names|
  names.each_with_index do |exercise_name, index|
    exercise = exercises.find { |record| record.name == exercise_name }
    ProgramDayExercise.find_or_create_by!(program_day: program_day, exercise: exercise) do |record|
      record.order_index = index + 1
    end
  end
end

puts "Seed complete! exercises=#{Exercise.count}, templates=#{ProgramTemplate.count}"
