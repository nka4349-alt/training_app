module Recommendations
  class StarterWeight
    def self.call(profile:, exercise:)
      return nil if exercise.equipment.include?("bodyweight")

      unit = profile.unit.to_sym
      eq = exercise.equipment

      if eq.include?("barbell")
        unit == :lb ? 45.0 : 20.0
      elsif eq.include?("dumbbell")
        unit == :lb ? 15.0 : 6.0
      else
        0.0
      end
    end
  end
end