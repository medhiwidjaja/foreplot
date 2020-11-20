require Rails.root.join('lib/tree_ext/tree_node.rb')

class ValueTreePresenter
  attr_reader :value_tree
  
  def initialize(value_tree, root_id, score_key: :score_g, &block)
    @value_tree = value_tree
    @tree = value_tree.build_tree(root_id, &block) 
    @score_key = score_key
  end

  def score_table
    score_table_from_tree(tree)
  end

  def score_table_from_tree(decision_tree, ranked: true)
    ScoreTableCalculator.new(value_tree, decision_tree, score_key: score_key, ranked: ranked).call
  end

  private

  attr_reader :score_key, :tree
end