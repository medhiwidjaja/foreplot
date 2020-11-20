module Foreplot
 
  class DirectRanking
    attr_reader :results

    def initialize(choices, **options)
      @choices = choices.to_a.clone.map(&:clone)
      @options = options
      @results = []
    end

    def rank 
      scores = Foreplot::Direct::SmartScore.score( choices.map{|c| c[:value] }, **options )
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
