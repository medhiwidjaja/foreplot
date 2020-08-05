module Foreplot
  # Using simple direct method to normalize values and use the result to rank the choices
  # Input: choices in an array of hash of (id, rank)
  # e.g.: [{id:1, rank:3},{id:2, rank:2},{id:3, rank:1}]
  # Output: results array
  #  [{id:, rank:, score:}]

  class MagiqRanking 
    include Foreplot::Magiq::OrdinalScore

    attr_reader :results

    def initialize(choices)
      @choices = choices.to_a.clone.map(&:clone)  # Deep cloning within the array
      @results = []
    end

    # Score the choice based on it's rank i, within k number of choices
    # Use the supplied rank_method (:rank_order_centroid, :rank_sum, :rank_reciprocal, :rank_exponential)
    #  use :rank_order_centroid if none supplied
    def rank(rank_method = :rank_order_centroid)
      k = @choices.size
      @results = @choices
        .sort_by {|c| c[:rank] }
        .collect {|c| 
          c.update( {score: send(rank_method, k, c[:rank])} )
        }
    end
  end

end
