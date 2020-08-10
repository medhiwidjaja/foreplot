class CriterionPresenter < BasePresenter
  attr_reader :article, :member

  def initialize(presentable, curr_user=nil, params*)
    super
    @member_id = params[:member_id] || current_user.id
    article_id = params[:article_id] || @presentable.article_id
    @article   = Article.find article_id
    @member    = @article.members.find_by user_id: @member_id
  end

  def criteria
    article.criteria
  end

  def tree
    @tree ||= article.criteria.root.to_tree
  end

  def parent
    @parent ||= @presentable.parent
  end

  def appraisal
    @appraisal ||= @presentable.appraisals.find_by member_id: @member_id
  end

  def table
    @table ||= @appraisal.relevant_comparisons.map {|c| {no: 1, title: c.title, rank:c.rank, score:c.score, score_n:c.score_n }}
  end

end