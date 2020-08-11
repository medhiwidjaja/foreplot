class DirectComparisonCalculatorService < BaseCalculatorService
  attr_reader :comparisons, :result
  def initialize(comparisons)
    @comparisons = comparisons
  end

  def call
    @result = convert_to_attributes Foreplot::DirectRanking.new(params(comparisons)).rank
  end

  private 

  def params(comparisons)
    comparisons.map {|id,param| {id:id, value:param["value"].to_f}}
  end
end
