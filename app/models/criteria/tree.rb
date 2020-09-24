class Criteria::Tree < Criteria::TreeBase

  attr_reader :tree

  def initialize(article_id, member_id)
    query = Criterion.with_children.where(article_id: article_id)
    query = query.with_appraisals_by(member_id) if member_id
    super(query)
  end

  def get_tree(root_id)
    @tree = build_tree(data[root_id]) do |c| 
      { id: c.id, 
        label: c.title, 
        weights_incomplete: !c.is_complete && c.subnodes.present?,
        ratings_incomplete: !c.is_complete && c.subnodes.blank?
      } 
    end
  end

  def as_json_tree(root_id)
    get_tree(root_id).to_json
  end

end