class DirectComparisonsController < ApplicationController
  include TurbolinksCacheControl
  include ComparisonConcern

  def new
    @form = DirectComparisonsForm.new @appraisal
  end

  def edit
    @form = DirectComparisonsForm.new @appraisal
  end

  def create
    @form = DirectComparisonsForm.new @appraisal, direct_comparisons_form_params
    if @form.submit
      redirect_to @form.redirect_url(@criterion), notice: 'Direct comparisons saved'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @form = DirectComparisonsForm.new @appraisal, direct_comparisons_form_params
    if @form.submit
      redirect_to @form.redirect_url(@criterion), notice: 'Direct comparisons updated'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

    def direct_comparisons_form_params
      params.require(:direct_comparisons_form).permit(:criterion_id, :member_id, :appraisal_method, :minimize, 
        :range_max, :range_min, :normalize,
        {direct_comparisons_attributes: 
          [:id, :comparable_id, :comparable_type, :title, :notes, :comparison_method, :value, :unit, :appraisal_id,
           :position, :score, :score_n, :rank]
        })
    end
end
