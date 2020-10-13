# Extension to the Tree::TreeNode class
module Tree
  class TreeNode

    # search for the whole tree and return the node matching the node_name
    # if detached is true, a detached copy of the node is returned
    # default to false
    def search_node(node_name, detached: false)
      match = nil
      root.each do |n| 
        if n.name == node_name.to_s
          match = n
          break
        end
      end
      detached ? match.detached_copy : match
    end

    # Update (add or update) the node's content
    def update_content(key:, value:)
      content.update(key => value)
    end
  end
end