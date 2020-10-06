class SensitivityController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_article
  before_action :set_criterion
  before_action :set_member

  def index
    @criteria_presenter = CriterionPresenter.new @root, current_user, {member_id: params[:member_id]}
  end

  def data
    value_tree = ValueTree.new @article.id, @member.id
    @presenter = SensitivityPresenter.new value_tree, @root.id, @criterion.id
    respond_to do |format|
      format.json 
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_criterion
    @root = @article.criteria.root
    @criterion = params[:criterion_id] ? 
                  Criterion.find(params[:criterion_id]) : 
                  @root.children.order(:position).first
  end

  def set_member
    @member = params[:member_id] ? Member.find(params[:member_id]) : @article.members.author.take
  end

end