module Foreplot
  # Using simple direct method to normalize values and use the result to rank the choices
  # Input: choices in an array of hash of (id, value)
  # e.g.: [{id:1, value:1.0},{id:2, value:2.0},{id:3, value:4.0}]
  # Output: results array
  # [{:id=>3, :value=>4.0, :score=>0.5714285714285714, :score_n=>0.5714285714285714, :rank=>1}, {:id=>2, :value=>2.0, :score=>0.2857142857142857, :score_n=>0.2857142857142857, :rank=>2}, {:id=>1, :value=>1.0, :score=>0.14285714285714285, :score_n=>0.14285714285714285, :rank=>3}]
  
  class DirectRanking
    attr_reader :results

    def initialize(choices, **options)
      @choices = choices.to_a.clone.map(&:clone)
      @options = options
      @results = []
    end

    def rank 
      scores = Foreplot::Direct::SmartScore.score( choices.map{|c| c[:value] }, options )
      total = scores.sum
      @results = choices
        .map.with_index { |c, i| 
          c.update( { score: scores[i], score_n: scores[i]/total } ) 
        }
        .sort_by {|c| c[:score] }
        .reverse
        .map.with_index(1) {|c,i| c.update({rank:i}) }
    end

    private

    attr_reader :choices, :options
  end

end
