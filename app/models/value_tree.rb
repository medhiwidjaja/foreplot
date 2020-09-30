class ValueTree

  attr_reader :tree, :tree_data, :score_data, :article_id, :member_id

  def initialize(article_id, member_id)
    @article_id = article_id
    @member_id = member_id
    @tree_data = tree_hash 
    @score_data = score_hash
  end

  def build_tree(node_id, type='Criterion', criterion_id=nil, &block)
    node = tree_data[ "#{node_id}-#{type}" ]
    record = score_data[ "#{criterion_id}-#{type}-#{node_id}" ]
    content = record ? block.call(record) : {id: node_id, title: node[:title]}

    branch = Tree::TreeNode.new(node_id.to_s, content)
    unless node[:subnodes].blank?
      node[:subnodes].each do |subnode| 
        new_branch = build_tree(subnode, node[:type], node_id, &block)
        branch << new_branch unless new_branch.nil?
      end
    end
    @tree = branch
  end

  def normalize!(weight)
    tree.each do |node|
      unless node.is_root?
        node.parent.content.update(sum: node.parent.children.sum {|child| child.content[weight] } )
        node.content.update((weight.to_s+"_n").to_sym => node.content[weight].to_f / node.parent.content[:sum].to_f)
      end
    end
  end

  def globalize!(weight)
    w_n = (weight.to_s+"_n").to_sym
    w_g = (weight.to_s+"_g").to_sym
    
    tree.each do |node|
      if node.is_root?
        global_weight = 1     # global weight of root is always 1
      else
        global_weight = (node.parent.content[w_g] || 0) * (node.content[w_n] || 0)
      end
      node.content.update(w_g => global_weight)
    end
  end

  def get_tree_node(node_name)
    match = nil
    tree.each do |n| 
      if n.name == node_name.to_s
        match = n
        break
      end
    end
    match
  end

  private

  def tree_query
    sql_params = ActiveRecord::Base.send(:sanitize_sql_array, [<<-SQL.squish, member_id: member_id, article_id: article_id])
      WITH parent_children as (
        SELECT DISTINCT 
          c.id, c.title, c.parent_id, 
          cmp.comparable_type as type, 
          array_agg(cmp.comparable_id) OVER (PARTITION BY a.id) as children
        FROM criteria c 
        INNER JOIN appraisals a ON a.criterion_id = c.id
        INNER JOIN comparisons cmp ON cmp.appraisal_id = a.id AND a.member_id = :member_id
        WHERE c.article_id = :article_id
      )

      SELECT 
        pc.id, pc.title, pc.parent_id, pc.type, pc.children,
        pc.id || '-' || 'Criterion' as idx
      FROM parent_children pc

      UNION

      SELECT a.id, a.title, NULL, 'Alternative', array[]::bigint[], a.id || '-' || 'Alternative'
      FROM alternatives a,  parent_children
      WHERE a.id = ANY(parent_children.children)
    SQL
    ActiveRecord::Base.connection.execute(sql_params).entries
  end

  def tree_hash
    tree_query.reduce({}) do |acc,record| 
      acc.merge({record['idx'] => record.symbolize_keys.merge(:subnodes => make_array(record['children']))})
    end
  end

  def score_query
    Comparison.find_by_sql([<<-SQL.squish, member_id: member_id, article_id: article_id])
      SELECT DISTINCT 
        c.id || '-' || cmp.comparable_type || '-' || cmp.comparable_id as idx, 
        cmp.id, a.criterion_id as cid, comparable.title, cmp.comparable_id, cmp.comparable_type, cmp.score
      FROM comparisons cmp
      LEFT OUTER JOIN appraisals a ON cmp.appraisal_id = a.id AND a.member_id = :member_id
      LEFT OUTER JOIN criteria comparable ON comparable.id = cmp.comparable_id
      LEFT OUTER JOIN criteria c ON c.id = a.criterion_id
      WHERE c.article_id = :article_id AND cmp.comparable_type = 'Criterion'

      UNION

      SELECT DISTINCT 
        c.id || '-' || cmp.comparable_type || '-' || cmp.comparable_id as idx, 
        cmp.id, a.criterion_id as cid, comparable.title, cmp.comparable_id, cmp.comparable_type, cmp.score
      FROM comparisons cmp
      LEFT OUTER JOIN appraisals a ON cmp.appraisal_id = a.id AND a.member_id = :member_id
      LEFT OUTER JOIN alternatives comparable ON comparable.id = cmp.comparable_id
      LEFT OUTER JOIN criteria c ON c.id = a.criterion_id
      WHERE c.article_id = :article_id AND cmp.comparable_type = 'Alternative'
    SQL
  end

  def score_hash
    score_query.reduce({}) do |acc,record| 
      acc.merge({record.idx => record}) 
    end
  end

  def make_array(str)
    str.slice(1..-2).split(',').map(&:to_i) if str
  end
end
