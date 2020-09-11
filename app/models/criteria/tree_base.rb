class Criteria::TreeBase

  def initialize(query)
    @data = query.reduce({}) {|acc,record| acc.merge({record.id => record}) }
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

  def search(id)
    data[id]
  end

  def children(parent_id)
    data.select {|id,node| data[parent_id].subnodes.include? id}.map {|k,v| v}
  end

  private
  attr_reader :data
  
end
