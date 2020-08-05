module Foreplot
  # Using simple direct method to normalize values and use the result to rank the choices
  # Input: choices in an array of hash of (id, value)
  # e.g.: [{id:1, value:1.0},{id:2, value:2.0},{id:3, value:4.0}]
  # Output: results array
  # [{:id=>3, :value=>4.0, :score=>0.5714285714285714, :score_n=>0.5714285714285714, :rank=>1}, {:id=>2, :value=>2.0, :score=>0.2857142857142857, :score_n=>0.2857142857142857, :rank=>2}, {:id=>1, :value=>1.0, :score=>0.14285714285714285, :score_n=>0.14285714285714285, :rank=>3}]
  
  class DirectRanking
    attr_reader :results, :total

    def initialize(choices)
      @choices = choices.to_a.clone.map(&:clone)
      @results = []
    end

    def rank 
      @total = @choices.collect {|c| c[:value]}.sum.to_f
      @results = @choices.collect {|c| 
          score = c[:value]/total
          c.update({score:score, score_n:score})
        }
        .sort_by {|c| c[:score] }
        .reverse
        .map.with_index(1) {|c,i| c.update({rank:i}) }
    end
  end

end
