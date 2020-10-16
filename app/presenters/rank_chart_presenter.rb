class RankChartPresenter < ValueTreePresenter

  def initialize(value_tree, root_id, score_key: :score_g)
    super(value_tree, root_id, score_key: :score_g) {|n| 
      {:id => n.comparable_id, :title => n.title, :score => n.score, :criterion => n.cid} 
    } 
  end

  def chart_data
    score_table.map {|_k, alt| alt[:score] }
  end

  def detail_chart_data
    score_table.map {|_, a| a[:detail].map {|_,v| v[:score]}}.transpose
  end

  def criteria_labels
    score_table.first[1][:detail].map {|_,v| v[:label]}
  end

  def alternative_names
    score_table.map {|_k, alt| alt[:title] }
  end

  def chart_data_json
    { chart_data: chart_data,
      labels:     alternative_names,
      names:      alternative_names }.to_json
  end

  def stacked_chart_data_json
    { chart_data:   detail_chart_data,
      tick_labels:  alternative_names,
      series_names: criteria_labels }.to_json
  end

end