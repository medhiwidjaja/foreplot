# Build tree recursively
def tree_builder(json, node)
  json.label node.name
  json.id    node.id

  unless node.children.empty?
    json.children do
      json.array! node.children do |child|
        tree_builder(json, child)
      end
    end
  end
end

tree_builder json, node
