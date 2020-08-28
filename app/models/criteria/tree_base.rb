class Criteria::TreeBase

  attr_reader :tree

  def initialize(query)
    @data = query.reduce({}) {|acc,record| acc.merge({record.id => record}) }
    @tree = {}
  end

  def build_tree(node, &proc)
    hash = proc.call node
    unless node.subnodes.blank?
      hash[:children]  = node.subnodes.sort.collect do |child_id|
        build_tree(data[child_id], &proc)
      end
    end
    hash
  end

  private

  attr_reader :data

end
