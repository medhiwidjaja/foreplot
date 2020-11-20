class ScoreTableCalculator 

  def initialize(value_tree, decision_tree, score_key: :score_g, ranked: true)
    @value_tree = value_tree
    @decision_tree = decision_tree
    @score_key = score_key
    @ranked = ranked
  end

  def call
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

  private

  attr_reader :value_tree, :decision_tree, :score_key, :ranked

  def collect_scores(alt_array)
    { 
      id:     alt_array.first[:id], 
      title:  alt_array.first[:title], 
      score:  alt_array.sum{ |a| a[score_key] },
      detail: alt_array.collect{ |a| a[:parent] }.reduce({}){ |acc,h| acc.merge(h) }
    }
  end
end