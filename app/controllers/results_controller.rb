class ResultsController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_article
  before_action :set_criterion
  before_action :set_member
  before_action :set_criterion_presenter, only: :index
  before_action :set_rank_chart_presenter, only: [:index, :chart]

  def index
    respond_to do |format|
      format.html 
      format.json
    end
  end

  def chart 
    respond_to do |format|
      format.json { @presenter = @rank_chart_presenter }
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

  def set_criterion_presenter
    @criteria_presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id]}
  end

  def set_rank_chart_presenter
    @value_tree = ValueTree.new @article.id, @member.id
    @rank_chart_presenter = RankChartPresenter.new @value_tree, @criterion.id
  end

end
