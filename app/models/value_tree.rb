class ValueTree

  attr_reader :tree_data, :score_data, :article_id, :member_id

  def initialize(article_id, member_id, root_id)
    @article_id = article_id
    @member_id = member_id
    @tree_data = tree_hash 
    @score_data = score_hash
    @root_id = root_id
  end

  def build_tree(node_id, type, &block)
    node = tree_data[ "#{node_id}-#{type}" ]
    record = score_data[ "#{node_id}-#{node['type']}" ]
    content = block.call(record) if record
    branch = Tree::TreeNode.new(node_id.to_s, content)
    unless node['subnodes'].blank?
      node['subnodes'].each do |subnode| 
        new_branch = build_tree(subnode, node['type'], &block)
        branch << new_branch unless new_branch.nil?
      end
    end
    branch
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
        LEFT OUTER JOIN appraisals a ON a.criterion_id = c.id 
        LEFT OUTER JOIN comparisons cmp ON cmp.appraisal_id = a.id AND a.is_valid = true AND a.member_id = :member_id
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
      acc.merge({record['idx'] => record.merge('subnodes' => make_array(record['children']))})
    end
  end

  def score_query
    Comparison.find_by_sql([<<-SQL.squish, member_id: member_id, article_id: article_id])
      SELECT DISTINCT 
        c.id || '-' || cmp.comparable_type || '-' || cmp.comparable_id as idx, 
        cmp.id, a.criterion_id as cid, comparable.title, cmp.comparable_id, cmp.comparable_type, cmp.score
      FROM comparisons cmp
      LEFT OUTER JOIN appraisals a ON cmp.appraisal_id = a.id AND a.is_valid = true AND a.member_id = :member_id
      LEFT OUTER JOIN criteria comparable ON comparable.id = cmp.comparable_id
      LEFT OUTER JOIN criteria c ON c.id = a.criterion_id
      WHERE c.article_id = :article_id AND cmp.comparable_type = 'Criterion'

      UNION

      SELECT DISTINCT 
        c.id || '-' || cmp.comparable_type || '-' || cmp.comparable_id as idx, 
        cmp.id, a.criterion_id as cid, comparable.title, cmp.comparable_id, cmp.comparable_type, cmp.score
      FROM comparisons cmp
      LEFT OUTER JOIN appraisals a ON cmp.appraisal_id = a.id AND a.is_valid = true AND a.member_id = :member_id
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
