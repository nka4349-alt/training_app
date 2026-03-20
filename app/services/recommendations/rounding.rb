module Recommendations
  class Rounding
    def self.round_to_step(value, step)
      return value if value.nil?
      s = step.to_f
      return value if s <= 0
      ((value.to_f / s).round * s).round(2)
    end
  end
end