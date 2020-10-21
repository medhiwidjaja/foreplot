class VizController < ApplicationController
  include TurbolinksCacheControl
  skip_before_action :authenticate_user!

  before_action :set_article
  before_action :set_criterion
  before_action :set_member

  def index
    authorize! :read, @article
    @criteria_presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id]}
    @value_tree = ValueTree.new @article.id, @member.id
  end

  def sankey
    authorize! :read, @article
    @value_tree = ValueTree.new @article.id, @member.id
    @sankey_presenter = SankeyPresenter.new @value_tree, @criterion.id
    respond_to do |format|
      format.json { @presenter = @sankey_presenter }
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_criterion
    @criterion = params[:criterion_id] ? Criterion.find(params[:criterion_id]) : @article.criteria.root
  end

  def set_member
    @member = params[:member_id] ? Member.find(params[:member_id]) : @article.members.author.take
  end

end
