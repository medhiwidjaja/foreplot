# Build tree recursively
def tree_builder(json, node, member_id)
  json.label               node.title
  json.id                  node.id
  if member_id
    json.weights_incomplete  node.appraisals.blank?
  end
  
  unless node.children.empty?
    json.children do
      json.array! node.children do |child|
        tree_builder(json, child, member_id)
      end
    end
  end
end

tree_builder json, node, member_id
