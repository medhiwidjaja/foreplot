class SensitivityController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_article
  before_action :set_member

  def index
    root = @article.criteria.root
    @criteria_presenter = CriterionPresenter.new root, current_user, {member_id: params[:member_id]}
    @criterion = root.children.first
  end

  def data
    value_tree = ValueTree.new @article.id, @member.id
    root = @article.criteria.root
    @criterion = root.children.order(:position).first
    @presenter = SensitivityPresenter.new value_tree, root.id, params[:cid] || @criterion.id
    respond_to do |format|
      format.json 
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_member
    @member = params[:member_id] ? Member.find(params[:member_id]) : @article.members.author.take
  end

end