class RatingsController < ApplicationController
  include TurbolinksCacheControl

  before_action :set_criterion
  before_action :set_presenter

  def index
    respond_to do |format|
      format.html 
      format.js 
    end
  end

  private

  def set_criterion
    @criterion = Criterion.includes(:appraisals).find(params[:criterion_id])
  end

  def set_presenter
    @presenter = CriterionPresenter.new @criterion, current_user, {member_id: params[:member_id], article_id: params[:article_id]}
  end
end
