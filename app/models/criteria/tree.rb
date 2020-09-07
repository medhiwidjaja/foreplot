class Criteria::Tree < Criteria::TreeBase

  attr_reader :tree, :query

  def initialize(article_id, member_id)
    query = Criterion.with_children.where(article_id: article_id)
    @query = query.with_appraisals_by(member_id) if member_id
    super(@query)
  end

  def get_tree(root_id)
    @tree = build_tree(data[root_id]) do |c| 
      {id: c.id, label: c.title, weights_incomplete: !c.is_complete && c.subnodes.present? } 
    end
  end

  def as_json_tree(root_id)
    get_tree(root_id).to_json
  end

  # TODO: move nodes (move_above, move_below, move_to_top)

end