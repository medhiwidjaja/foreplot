class SensitivityPresenter < ValueTreePresenter

  attr_reader :chart_data, :criterion_id, :title

  def initialize(value_tree, root_id, criterion_id, score_key: :score_g)
    @vt = value_tree
    @criterion_id = criterion_id.to_i
    @title = Criterion.find(criterion_id).title
    super(value_tree, root_id, score_key: :score_g) {|n| 
      {:id => n.comparable_id, :title => n.title, :score => n.score, :criterion => n.cid} 
    } 
    @chart_data = score_table.map {|_k, alt| alt[:score] }
    sensitivity_for(criterion_id)
  end

  def sensitivity_data
    scores_min.collect {|key, p| [[0.0, p[:score]], [1.0, @scores_max[key][:score]]] }
  end

  def chart_labels
    scores_min.collect {|_, p| p[:title] } 
  end

  def weight
    vt.score_data.values.select {|c| c.comparable_id == criterion_id.to_i}.first.score.to_f
  end

  private

  attr_reader :vt, :scores_min, :scores_max

  def sensitivity_for(criterion_id)
    node = vt.get_tree_node criterion_id

    # Get intersection at score = 0 for the selected criterion
    node.content.update score: 0.0
    vt.normalize! :score
    vt.globalize! :score
    @scores_min = score_table.sort_by {|k,_| k}

    # Get intersection at score = max (among the siblings) for the selected criterion
    max_value = node.parent.children.collect{|c| c.content[:score]}.max 
    node.content.update score: max_value
    node.siblings.each {|sibling| sibling.content.update score: 0.0 }
    vt.normalize! :score
    vt.globalize! :score
    @scores_max = score_table
  end

end