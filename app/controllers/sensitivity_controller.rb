class SensitivityController < ApplicationController
  include TurbolinksCacheControl
  skip_before_action :authenticate_user!
  
  before_action :set_article
  before_action :set_criterion
  before_action :set_member

  def index
    authorize! :read, @article
    @criteria_presenter = CriterionPresenter.new @root, current_user, {member_id: params[:member_id]}
  end

  def data
    authorize! :read, @article
    value_tree = ValueTree.new @article.id, @member.id
    
    respond_to do |format|
      format.json do
        begin
          @presenter = SensitivityPresenter.new value_tree, @root.id, @criterion.id
        rescue => e
          render :json => {error: e.message, status: 400 }, :status => :bad_request
        end
      end
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