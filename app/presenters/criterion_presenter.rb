class CriterionPresenter < BasePresenter
  attr_reader :article, :member, :member_id
  
  def initialize(presentable, curr_user=nil, **params)
    super(presentable, curr_user)
    @article   = params[:article_id] ? Article.find(params[:article_id]) : @presentable.article
    @member = params[:member_id] ? Member.find(@params[:member_id]) : @article.members.find_by(user_id: current_user.id)
    @member_id = params[:member_id] || @member.id
  end

  def criterion
    @presentable
  end

  def criteria
    article.criteria
  end

  def root
    article.criteria.root
  end

  def as_tree
    @tree ||= article.criteria.root.to_tree
  end

  def parent
    @parent ||= @presentable.parent
  end

  def appraisal
    @appraisal ||= @presentable.appraisals.find_by member_id: @member_id
  end

  def table
    return nil if appraisal.nil?
    @table ||= appraisal.relevant_comparisons.map {|c| {no: 1, title: c.title, rank:c.rank, score:c.score, score_n:c.score_n }}
  end

end