class BaseCalculatorService

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

end