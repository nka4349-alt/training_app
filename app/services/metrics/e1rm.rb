module Metrics
  class E1RM
    def self.call(weight:, reps:)
      return nil if weight.nil? || reps.nil?
      weight.to_f * (1.0 + reps.to_f / 30.0) # Epley
    end
  end
end