class AssaysController < ApplicationController
  include TurbolinksCacheControl
  
  before_action :set_assay

  def direct
  end

  def rank
  end

  def pairwise
  end

  def update
  end

  private

    def set_assay
      @assay = Assay.find(params[:id])
    end

    def assay_params
      params.require(:assay).permit(:is_complete, :is_valid, :member_id, :criterion_id, :assay_method)
    end
end
