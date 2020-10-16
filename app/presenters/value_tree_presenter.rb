require Rails.root.join('lib/tree_ext/tree_node.rb')

class ValueTreePresenter
  attr_reader :score_key, :value_tree, :tree
  
  def initialize(value_tree, root_id, score_key: :score_g, &block)
    @value_tree = value_tree
    @tree = value_tree.build_tree(root_id, &block) 
    @score_key = score_key
  end

  def score_table
    score_table_from_tree(tree)
  end

  def score_table_from_tree(decision_tree, ranked: true)
    create_score_table(decision_tree, ranked: ranked)
  end

  private

  def create_score_table(decision_tree, ranked: true)
    global_decision_tree = value_tree.globalize decision_tree
    scores =
      global_decision_tree.each_leaf.map { |node| 
        node.content                                          # get the contents of each leaf node
          .merge(:parent => {node.parent.name.to_i => { score: node.content[score_key], label: node.parent.content[:title] }})
      }
      .group_by { |node| node[:id] }                          # group by alternative id
      .reduce({}) { |hash, ary| 
        hash.merge(ary.first => collect_scores(ary.last))     # combine and sum the scores of each alternative
      }
    
    if ranked
      scores = scores
        .sort_by { |id, alt| alt[:score] }                      # sort by score
        .reverse                                                # descending from high to low
        .each.with_index(1) {|x, idx| 
          x.last.update(rank: idx)                              # add rank number
        }
    else
      scores = scores
        .sort_by { |id, alt| alt[:id] } 
    end

    max_score = scores.max{ |a, b| a.last[:score] <=> b.last[:score] }.last[:score]
    scores.each { |_k,v| 
      v.update(ratio: v[:score].to_f/max_score)               # add normalized ratio = score/max_score
    }
    scores.to_h
  end

  def collect_scores(alt_array)
    { 
      id:     alt_array.first[:id], 
      title:  alt_array.first[:title], 
      score:  alt_array.sum{ |a| a[score_key] },
      detail: alt_array.collect{ |a| a[:parent] }.reduce({}){ |acc,h| acc.merge(h) }
    }
  end
end