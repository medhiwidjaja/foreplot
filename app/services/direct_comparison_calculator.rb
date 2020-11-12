class DirectComparisonCalculator < BaseCalculator
  attr_reader :comparisons, :result
  def initialize(comparisons, **options)
    @comparisons = comparisons
    @options = options
  end

  def call
    @result = convert_to_attributes Foreplot::DirectRanking.new(params(comparisons), **@options).rank
  end

  private 

  def params(comparisons)
    comparisons.map {|id,param| {id:id, value:param["value"].to_f}}
  end
end
