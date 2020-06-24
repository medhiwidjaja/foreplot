class Criteria::Tree < Tree::TreeNode

  # Example:
  #     Criteria::Tree.build_tree(criterion) { |node| node.attributes }
  def self.build_tree(criterion, &proc)
    node = new(criterion.title, proc.call(criterion))
    unless criterion.children.empty?
      criterion.children.collect { |child| node << Criteria::Tree.build_tree(child, &proc) }
    end 
    node
  end

  def pretty_print 
    self.collect do |n| 
      puts "#{'  '*n.node_depth}- #{n.name}:\t #{yield n}"
    end 
  end

  def method_missing(method, *args, &block)
    if content.keys.include? method.to_s
      content[method.to_s]
    else
      raise NoMethodError
    end
  end

end
