class SankeyPresenter

  attr_reader :nodes, :links

  def initialize(value_tree, root_id, score_key: :score_g)
    value_tree.build_tree(root_id) {|n| {:id => n.comparable_id, :title => n.title, :score => n.score, :criterion => n.cid} } 
    value_tree.normalize! :score
    value_tree.globalize! :score
    @tree = value_tree.tree
    @score_key = score_key
    @nodes = []
    @links = []
  end

  def sankey_nodes
    tree.breadth_each do |node| 
      @nodes << { id: node.name, name: node.content[:title] } 
    end
    @nodes.uniq
  end

  def sankey_links
    tree.each do |node| 
      next if node.parent.nil? 
      @links << { source: node.parent.name, target: node.name, value: node.content[score_key] } 
    end
    @links
  end

  def sankey_data
    {nodes: nodes, links: links}.to_json
  end

  private

  attr_reader :tree, :score_key
end