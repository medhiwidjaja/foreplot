class SankeyPresenter < ValueTreePresenter

  attr_reader :nodes, :links

  def initialize(value_tree, root_id, score_key: :score_g)
    super(value_tree, root_id, score_key: :score_g) {|n| 
      {:id => n.comparable_id, :idx => "#{n.comparable_type}-#{n.comparable_id}", :title => n.title, :score => n.score, :criterion => n.cid} 
    } 
    @nodes = []
    @links = []
  end

  def sankey_nodes
    tree.breadth_each do |node| 
      @nodes << { id: node.content[:idx] || "Root-#{0}", name: node.content[:title] } 
    end
    @nodes.uniq
  end

  def sankey_links
    tree.each do |node| 
      next if node.parent.nil? 
      @links << { source: node.parent.content[:idx] || "Root-#{0}", target: node.content[:idx], value: node.content[score_key] } 
    end
    @links
  end

  def sankey_data
    {nodes: nodes, links: links}.to_json
  end

end