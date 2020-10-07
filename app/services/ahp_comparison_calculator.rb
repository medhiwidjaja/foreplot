class AHPComparisonCalculator < BaseCalculator
  attr_reader :comparisons, :cr, :result

  def initialize(pairwise_comparisons, choices)
    @comparisons = pairwise_comparisons
    @choices = choices
    @ahp = Foreplot::AHPRanking.new(symbolize_keys(@choices), entries(@choices, @comparisons))
    @ahp.rank
  end

  def call
    @result = convert_to_attributes @ahp.results
  end

  def cr
    @ahp.consistency_ratio
  end

  private
  
  # This method makes sure that the matrix parameter is correct regardless the order of the comparison pairs
  def entries(choices, comparisons)
    symbolize_keys(choices)
      .map { |c| c[:comparable_id]}.combination(2).map{|a| a }     # combination pairs of choice id's 
      .map { |p1, p2|                                              # get the corresponding pair from the comparisons
        symbolize_keys(comparisons.values)
          .select{|x| x[:comparable1_id].to_i == p1 && x[:comparable2_id].to_i == p2}
          .flatten     
      }
      .flatten
      .map {|v| v[:value].to_f }
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

  def symbolize_keys(ary)
    ary.map &:symbolize_keys
  end
end
