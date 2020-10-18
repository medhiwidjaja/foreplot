require Rails.root.join('lib/tree_ext/tree_node.rb')

class SensitivityPresenter < ValueTreePresenter

  attr_reader :criterion_id, :title

  def initialize(value_tree, root_id, criterion_id, score_key: :score_g)
    @criterion_id = criterion_id.to_i
    @criterion = Criterion.find(criterion_id)
    
    raise StandardError.new "Cannot do sensitivity analysis on single subcriterion" if @criterion.parent.children.size == 1

    @title = @criterion.title
    super(value_tree, root_id, score_key: score_key) {|n| 
      {:id => n.comparable_id, :title => n.title, :score => n.score, :criterion => n.cid} 
    } 
    @min_scores = scores_min(criterion_id)
    @max_scores = scores_max(criterion_id)
  end

  def sensitivity_data
    min_scores.collect {|key, p| [[0.0, p[:score]], [1.0, max_scores[key][:score]]] }
  end

  def chart_data
    score_table.sort_by {|_, alt| alt[:id]}.collect {|_, alt| alt[:score] }
  end

  def chart_labels
    score_table.sort_by {|_, alt| alt[:id]}.collect {|_, alt| alt[:title] } 
  end

  def weight
    value_tree.score_data.select{|k,_| k.match /Criterion-#{criterion_id.to_i}/}.values[0][:score].to_f
  end

  private

  attr_reader :min_scores, :max_scores

  def scores_min(id)
    criteria_tree = value_tree.tree.dup
    node = criteria_tree.search_node("#{id}-Criterion")
            .content.update(score: 0.0)
    score_table_from_tree(criteria_tree, ranked: false)
  end

  def scores_max(id)
    criteria_tree = value_tree.tree.dup
    node = criteria_tree.search_node("#{id}-Criterion")
    siblings_max_scores = node.parent.children.collect{|c| c.content[:score]}.max 
    node.content.update(score: siblings_max_scores)
    node.siblings.each {|sibling| sibling.content.update score: 0.0 }
    score_table_from_tree(criteria_tree, ranked: false)
  end

end

