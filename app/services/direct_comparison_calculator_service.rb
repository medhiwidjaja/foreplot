class DirectComparisonCalculatorService
  def call(comparisons)
    Foreplot::DirectRanking.new(params(comparisons)).rank
  end

  private

  def params(comparisons)
    comparisons.map {|c| {id:c.id, value:c.value}}
  end
end
