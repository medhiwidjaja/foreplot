class ValueTreePresenter

  attr_reader :tree

  def initialize(value_tree, root_id, score_key: :score_g)
    value_tree.build_tree(root_id) {|n| {:id => n.comparable_id, :title => n.title, :score => n.score, :criterion => n.cid} } 
    value_tree.normalize! :score
    value_tree.globalize! :score
    @tree = value_tree.tree
    @score_key = score_key
  end

  def score_table
    scores =
      tree.each_leaf.map { |node| 
        node.content                                          # get the contents of each leaf node
          .merge(:criterion => {node.parent.name => node.content[score_key]})
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
    scores.each { |k,v| 
      v.update(ratio: v[:score].to_f/max_score)               # add normalized ratio = score/max_score
    }
    scores.to_h
  end

  def chart_data
    score_table.map {|a| a[:score] }
  end

  def detail_chart_data
    score_table.map {|a| a[:criterion].map {|o| o.last } }.transpose
  end

  def criteria_labels
    score_table.first[:criterion].map {|o| @article.criteria.find(o.first).title }
  end

  def alternative_labels
    score_table.map {|a| split_lines(a[:abbrev].blank? ? a[:title] : a[:abbrev]) }
  end

  def alternative_names
    score_table.map {|a| a[:title] }
  end

  private

  attr_reader :score_key

  def collect_scores(alt_array)
    { 
      id:           alt_array.first[:id], 
      title:        alt_array.first[:title], 
      score:        alt_array.sum { |a| a[score_key] } 
    }
  end

end