class AHPComparisonCalculator < BaseCalculator
  attr_reader :comparisons, :cr, :result

  def initialize(pairwise_comparisons, choices)
    @comparisons = pairwise_comparisons
    @choices = choices
    @ahp = Foreplot::AHPRanking.new(choice_array(@choices), entries(@comparisons))
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
    choices.map &:symbolize_keys
  end
  
  def entries(comparisons)
    comparisons
      .sort_by {|k,v| [v["comparable1_id"], v["comparable2_id"]] }
      .map {|k,v| v["value"].to_f }
  end

  def convert_to_attributes(result)
    result.each_with_index.reduce(Hash.new) do |acc, (r, idx)|
      acc.merge( {"#{r[:id] || idx}" => 
        param_hash(r, except: [:name]).merge(
          {"comparable_id" => "#{r[:comparable_id]}", "comparable_type" => "#{r[:comparable_type]}", "title" =>  "#{r[:name]}" }
        ) 
      } )
    end
  end 

end
