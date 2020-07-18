class AssaysController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_criterion, only: [:direct, :rank, :pairwise, :create]
  before_action :set_assay, only: [:update, :destroy]

  def direct
    assay_service = AssayService.new(@criterion)
    @assay = assay_service.find_or_initialize
    @direct_comparisons = assay_service.direct_comparisons
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

    def set_assay
      @assay = Assay.find(params[:id])
    end

    def set_criterion
      @criterion = Criterion.find(params[:criterion_id])
    end

    def assay_params
      params.require(:assay).permit(:is_complete, :is_valid, :member_id, :criterion_id, :assay_method)
    end
end
