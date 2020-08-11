class MagiqComparisonCalculatorService < BaseCalculatorService
  attr_reader :comparisons, :result
  def initialize(comparisons)
    @comparisons = comparisons
  end

  def call
    @result = convert_to_attributes Foreplot::MagiqRanking.new(params(comparisons)).rank
  end

  private 

  def params(comparisons)
    comparisons.map {|id,param| {id:id, rank:param["rank"].to_i}}
  end
end
