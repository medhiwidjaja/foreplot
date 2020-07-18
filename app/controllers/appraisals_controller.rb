class AppraisalsController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_criterion, only: [:direct, :rank, :pairwise, :create]
  before_action :set_appraisal, only: [:update, :destroy]

  def direct
    appraisal_service = AppraisalService.new(@criterion)
    @appraisal = appraisal_service.find_or_initialize
    @direct_comparisons = appraisal_service.direct_comparisons
  end

  def rank
  end

  def pairwise
  end

  def update
  end

  def destroy
  end

  private

    def set_appraisal
      @appraisal = Appraisal.find(params[:id])
    end

    def set_criterion
      @criterion = Criterion.find(params[:criterion_id])
    end

    def appraisal_params
      params.require(:appraisal).permit(:is_complete, :is_valid, :member_id, :criterion_id, :appraisal_method)
    end
end
