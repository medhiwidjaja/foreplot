class CriterionPresenter < BasePresenter
  attr_reader :article, :member, :member_id
  
  def initialize(presentable, curr_user=nil, **params)
    super(presentable, curr_user)
    @article   = params[:article_id] ? Article.with_criteria.find(params[:article_id]) : @presentable.article
    @member = params[:member_id] ? Member.find(params[:member_id]) : relevant_member(@article)
    @member_id = params[:member_id] || @member.id
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
    @root ||= article.criteria.root
  end

  def appraisal
    @appraisal ||= @presentable.appraisals.where(comparable_type: comparable_type).find_by member_id: @member_id
  end

  def comparable_type
    @comparable_type ||= @presentable.children.exists? ? 'Criterion' : 'Alternative'
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
      &.order(:position)
      &.map {|c| {no: c.position, title: c.title, rank:c.rank, value:c.value, score:c.score.to_f, score_n:c.score_n.to_f }}
  end

  def comparison_type
    appraisal&.appraisal_method
  end

  def comparison_name
    appraisal&.comparison_name
  end

  def allow_navigate
    true
  end

  def confirm_destroy_related_appraisals
    if @presentable.appraisals.present? || @presentable.parent&.appraisals&.present?
      {confirm: "This action will delete all related comparisons previously created by you and/or other participants (if any).\n\nAre you sure to proceed?"}
    end
  end

  private

  def relevant_member(article)
    article.members.with_user_id(current_user.id).take || article.members.author.take
  end

end