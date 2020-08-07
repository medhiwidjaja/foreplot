class DirectComparisonCalculatorService
  attr_reader :comparisons, :result
  def initialize(comparisons)
    @comparisons = comparisons
  end

  def call
    result = convert_to_attributes Foreplot::DirectRanking.new(params(comparisons)).rank
  end

  private

  def convert_to_attributes(result)
    result.reduce(Hash.new) do |acc, r|
      acc.merge( {r[:id] => param_hash(r)} )
    end
    .merge(comparisons) {|k,r,c| r.merge(c)}
  end 

  def param_hash(row)
    row.except(:id).reduce(Hash.new) do |acc,kv| 
      acc.merge( {kv.first.to_s => kv.last.to_s} ) 
    end
  end

  def params(comparisons)
    comparisons.map {|id,param| {id:id, value:param["value"].to_f}}
  end
end
