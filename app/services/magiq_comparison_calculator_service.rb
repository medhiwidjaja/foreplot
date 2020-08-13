class MagiqComparisonCalculatorService < BaseCalculatorService
  attr_reader :comparisons, :result
  def initialize(comparisons)
    @comparisons = comparisons
  end

  def call
    @result = convert_to_attributes(
      add_score_n_field(
        Foreplot::MagiqRanking.new(params(comparisons)).rank
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
