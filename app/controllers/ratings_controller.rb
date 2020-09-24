class RatingsController < ApplicationController
  include TurbolinksCacheControl

  def index
    @article = Article.find params[:article_id]
    @criterion = @article.criteria.root 
    @presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id], article_id: params[:article_id]}
  end

  def show
    @criterion = Criterion.includes(:appraisals).find(params[:criterion_id])
    @presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id], article_id: params[:article_id]}
    respond_to do |format|
      format.html 
      format.js 
    end
  end

end
