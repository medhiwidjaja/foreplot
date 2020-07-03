module Foreplot
  module Decision

    # Using simple Analytic Hierarchy Process to score and use the result to rank the choices
    # Input: choices in an array of hash of pairwise comparison (id1, id2, value)
    # Output: results array
    #     
    class AhpRanking
      attr_reader :results, :consistency_ratio

      def initialize(choices, decision_matrix)
        @choices = choices.to_a.clone.map(&:clone)
        @ahp = Foreplot::Decision::Ahp::AnalyticHierarchyProcess.new decision_matrix, choices.size
        @results = []
      end

      def rank 
        @results = @choices.zip(@ahp.pv).collect {|choice, weight| 
          choice.update({score:weight, score_n:weight})
        }
        .sort_by {|c| c[:score] }
        .reverse
        .map.with_index(1) {|c,i| c.update({rank:i}) }
      end

      def consistency_ratio
        @ahp.cr
      end
    end
  end
end
