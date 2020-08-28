class AHPComparisonCalculator < BaseCalculator
  attr_reader :comparisons, :cr, :result

  def initialize(pairwise_comparisons, choices)
    @comparisons = pairwise_comparisons
    @choices = choices
    @ahp = Foreplot::AHPRanking.new(choice_array(@choices), entries)
    @ahp.rank
  end

  def call
    @result = convert_to_attributes @ahp.results
  end

  def cr
    @ahp.consistency_ratio
  end

  private 

  def choice_array(choices)
    choices.map {|choice| {id: choice["id"].to_i, name: choice["name"] } }
  end
  
  def entries
    comparisons
      .sort_by {|k,v| [v["comparable1_id"], v["comparable2_id"]] }
      .map {|k,v| v["value"].to_f }
  end

  def convert_to_attributes(result)
    result.reduce(Hash.new) do |acc, r|
      acc.merge( {"#{r[:id]}" => param_hash(r)} )
    end
  end 

end
