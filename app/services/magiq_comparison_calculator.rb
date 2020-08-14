class MagiqComparisonCalculator < BaseCalculator
  attr_reader :comparisons, :rank_method, :result

  def initialize(comparisons, rank_method='rank_order_centroid')
    @comparisons = comparisons
    @rank_method = rank_method
  end

  def call
    @result = convert_to_attributes(
      add_score_n_field(
        Foreplot::MagiqRanking.new(params(comparisons)).rank(rank_method)
      ))
  end

  private 

  def add_score_n_field(hash)
    hash.map {|x| x.merge({score_n:x[:score]}) }
  end
  
  def params(comparisons)
    comparisons.map {|id,param| {id:id, rank:param["rank"].to_i}}
  end
end
