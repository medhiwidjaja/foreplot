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
    score_table.map {|_k, alt| alt[:score] }
  end

  def chart_labels
    score_table.collect {|_, p| p[:title] } 
  end

  def weight
    value_tree.score_data.values.select {|c| c.comparable_id == criterion_id.to_i}.first.score.to_f
  end

  private

  attr_reader :min_scores, :max_scores

  def scores_min(id)
    criteria_tree = value_tree.tree.dup
    node = criteria_tree.search_node(id)
            .content.update(score: 0.0)
    score_table_from_tree(criteria_tree)
  end

  def scores_max(id)
    criteria_tree = value_tree.tree.dup
    node = criteria_tree.search_node(id)
    siblings_max_scores = node.parent.children.collect{|c| c.content[:score]}.max 
    node.content.update(score: siblings_max_scores)
    node.siblings.each {|sibling| sibling.content.update score: 0.0 }
    score_table_from_tree(criteria_tree)
  end

end

module Tree
  class TreeNode

    # search for the whole tree and return the node matching the node_name
    # if detached is true, a detached copy of the node is returned
    # default to false
    def search_node(node_name, detached=false)
      match = nil
      root.each do |n| 
        if n.name == node_name.to_s
          match = n
          break
        end
      end
      detached ? match.detached_copy : match
    end

  end
end