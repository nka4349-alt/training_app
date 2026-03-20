module Recommendations
  class RuleBasedNext
    def self.call(user:, workout_exercise:)
      profile = user.profile
      rep_min = workout_exercise.rep_range_min
      rep_max = workout_exercise.rep_range_max
      step    = profile.weight_step

      sets = workout_exercise.set_entries.select(&:done?)
      return empty_result(rep_min) if sets.empty?

      weight_current = most_common_weight(sets.map(&:weight).compact)
      avg_reps = sets.sum { |s| s.reps.to_i } / sets.size.to_f
      avg_rpe  = average_rpe(sets)
      had_failure = sets.any?(&:failed)

      rationale = []

      if had_failure
        next_weight = Rounding.round_to_step([weight_current.to_f - step.to_f, 0].max, step)
        rationale << { code: "FAILED_SET", message: "失敗セットあり → 次回は重量を下げて安定させます" }
        return { weight: next_weight, reps_target: rep_min, sets: workout_exercise.target_sets, rationale: rationale }
      end

      if avg_rpe && avg_rpe >= 9.0
        rationale << { code: "RPE_TOO_HIGH", message: "RPEが高め → 次回は重量据え置き" }
        return { weight: weight_current, reps_target: [avg_reps.round, rep_min].max, sets: workout_exercise.target_sets, rationale: rationale }
      end

      hit_top = sets.all? { |s| s.reps.to_i >= rep_max }
      if hit_top && (avg_rpe.nil? || avg_rpe <= 8.0)
        next_weight = Rounding.round_to_step(weight_current.to_f + step.to_f, step)
        rationale << { code: "HIT_TOP_REPS", message: "全セットで上限回数達成 → 次回は重量アップ" }
        return { weight: next_weight, reps_target: rep_min, sets: workout_exercise.target_sets, rationale: rationale }
      end

      in_range = sets.all? { |s| s.reps.to_i >= rep_min }
      if in_range
        reps_target = [avg_reps.round + 1, rep_max].min
        rationale << { code: "KEEP_WEIGHT", message: "レンジ内達成 → 重量据え置きで回数を伸ばす" }
        return { weight: weight_current, reps_target: reps_target, sets: workout_exercise.target_sets, rationale: rationale }
      end

      next_weight = Rounding.round_to_step([weight_current.to_f - step.to_f, 0].max, step)
      rationale << { code: "BELOW_MIN_REPS", message: "下限未達 → 次回は重量を下げます" }
      { weight: next_weight, reps_target: rep_min, sets: workout_exercise.target_sets, rationale: rationale }
    end

    def self.empty_result(rep_min)
      { weight: nil, reps_target: rep_min, sets: 3, rationale: [{ code: "NO_DATA", message: "データ不足のため据え置き" }] }
    end

    def self.average_rpe(sets)
      rpes = sets.map(&:rpe).compact
      return nil if rpes.empty?
      rpes.sum / rpes.size.to_f
    end

    def self.most_common_weight(weights)
      return nil if weights.empty?
      weights.group_by { |w| w.to_f.round(2) }.max_by { |_k, v| v.size }.first
    end
  end
end