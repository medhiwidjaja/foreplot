class CriterionPresenter < BasePresenter
  attr_reader :article, :member, :member_id, :appraisal
  
  def initialize(presentable, curr_user=nil, **params)
    super(presentable, curr_user)
    @article   = params[:article_id] ? Article.with_criteria.find(params[:article_id]) : @presentable.article
    @member = params[:member_id] ? Member.find(params[:member_id]) : relevant_member(@article)
    @member_id = params[:member_id] || @member.id
    comparable_type = @presentable.children.exists? ? 'Criterion' : 'Alternative'
    @appraisal = @presentable.appraisals.where(comparable_type: comparable_type).find_by member_id: @member_id
  end

  def criterion
    @presentable
  end

  def criteria
    article.criteria
  end

  def alternatives
    criterion.article.alternatives
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

  def parent_id
    @parent_id ||= (parent.id if parent.present?)
  end

  def table
    @table ||= appraisal&.relevant_comparisons
      &.includes(:comparable)
      &.order(:comparable_id)
      &.map {|c| {no: c.comparable&.position, title: c.comparable&.title, rank:c.rank, score:c.score, score_n:c.score_n }}
  end

  def comparison_type
    appraisal&.appraisal_method
  end

  def allow_navigate
    true
  end

  def confirm_destroy_related_appraisals
    {confirm: "Warning! All comparisons done related to the parent node will be destroyed."} if @presentable.appraisals.present?
  end

  private

  def relevant_member(article)
    article.members.with_user_id(current_user.id).take || article.members.author.take
  end

end