class ResultCalculator

  def initialize(article, node, member)
   
    return if member.nil? || node.nil? || article.nil?
    @article = article
    @node = node
    @member = member
    @member_id = member.id
    @alternatives = article.alternatives
  end

  def value_tree
    # vt = Foreplot::ValueTree.new 
    # vt.globalize! :weight
  end

end