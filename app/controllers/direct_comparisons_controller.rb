class DirectComparisonsController < ApplicationController

  before_action :set_comparison, only: [:edit, :update, :create]
  before_action :set_related_criterion, only: [:edit, :update, :create]
  before_action :set_criterion, only: :new
  before_action :set_related_article

  def new
    @comparisons 
  end

  def edit
    @appraisal = appraisal_service.appraisal
    @comparison = appraisal_service.get_comparisons
  end

  def create
  end

  def update
  end

  private
    def set_comparison
      @comparison = DirectComparison.find(params[:id])
    end

    def set_related_criterion
      @criterion = @comparison.criterion
    end

    def set_criterion
      @criterion = Criterion.find(params[:criterion_id])
    end

    def set_related_article
      @article = @criterion.article
    end

    def direct_comparisons_params
      params.require(:direct_comparison).permit(:comparable_id, :comparable_type, :title, :notes, :comparison_method, :value, :unit, :appraisal_id)
    end
end
