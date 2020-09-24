module Foreplot
  # Using simple direct method to normalize values and use the result to rank the choices
  # Input: choices in an array of hash of (id, rank)
  # e.g.: [{id:1, rank:3},{id:2, rank:2},{id:3, rank:1}]
  # Output: results array
  #  [{id:, rank:, score:}]

  class MagiqRanking 

    attr_reader :results

    def initialize(choices, rank_method = :rank_order_centroid)
      @choices = choices.to_a.clone.map(&:clone).sort_by {|c| c[:rank] }  # Deep cloned, sorted array
      @rank_method = rank_method
      @results = []
    end

    def rank
      scores = Foreplot::Magiq::OrdinalScore.score( choices.map{|c| c[:rank] }, rank_method )
      @results = choices.map.with_index { |c, i| c.update( {score: scores[i]} ) }
    end

    private

    attr_reader :choices, :rank_method

  end
end
