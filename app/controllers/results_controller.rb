class ResultsController < ApplicationController
  include TurbolinksCacheControl

  before_action :set_article
  before_action :set_presenter

  def index
    respond_to do |format|
      format.html 
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_presenter
    @presenter = ResultsPresenter.new @article, current_user, {member_id: params[:member_id], article_id: params[:article_id]}
  end
end
