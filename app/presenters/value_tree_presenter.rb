class ValueTreePresenter

  attr_reader :tree

  def initialize(value_tree, root_id, score_key: :score_g, &block)
    value_tree.build_tree(root_id, &block) 
    value_tree.normalize! :score
    value_tree.globalize! :score
    @tree = value_tree.tree
    @score_key = score_key
  end

  def score_table
    scores =
      tree.each_leaf.map { |node| 
        node.content                                          # get the contents of each leaf node
          .merge(:score => {node.parent.name.to_i => node.content[score_key]})
          .merge(:label => {node.parent.name.to_i => node.parent.content[:title]})
      }
      .group_by { |node| node[:id] }                          # group by alternative id
      .reduce({}) { |hash, ary| 
        hash.merge(ary.first => collect_scores(ary.last))     # combine and sum the scores of each alternative
      }
      .sort_by { |id, alt| alt[:score] }                      # sort by score
      .reverse                                                # descending from high to low
      .each.with_index(1) {|x, idx| 
        x.last.update(rank: idx)                              # add rank number
      }

    max_score = scores.max{ |a, b| a.last[:score] <=> b.last[:score] }.last[:score]
    scores.each { |_k,v| 
      v.update(ratio: v[:score].to_f/max_score)               # add normalized ratio = score/max_score
    }
    scores.to_h
  end

  private

  attr_reader :score_key

  def collect_scores(alt_array)
    { 
      id:     alt_array.first[:id], 
      title:  alt_array.first[:title], 
      score:  alt_array.sum{ |a| a[score_key] },
      detail: alt_array.collect{ |a| a[:score] }.reduce({}){ |acc,h| acc.merge(h) },
      labels: alt_array.collect{ |a| a[:label] }.reduce({}){ |acc,h| acc.merge(h) }
    }
  end
end