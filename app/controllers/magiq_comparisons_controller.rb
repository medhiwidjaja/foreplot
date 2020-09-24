
class MagiqComparisonsController < ApplicationController
  include TurbolinksCacheControl
  include ComparisonConcern

  def new
    @form = MagiqComparisonsForm.new @appraisal
  end

  def edit
    @form = MagiqComparisonsForm.new @appraisal
  end

  def create
    @form = MagiqComparisonsForm.new @appraisal, magiq_comparisons_form_params
    if @form.submit
      redirect_to @form.redirect_url(@criterion), notice: 'Magiq comparisons saved'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @form = MagiqComparisonsForm.new @appraisal, magiq_comparisons_form_params
    if @form.submit
      redirect_to @form.redirect_url(@criterion), notice: 'Magiq comparisons updated'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

    def magiq_comparisons_form_params
      params.require(:magiq_comparisons_form).permit(:criterion_id, :member_id, :appraisal_method, :rank_method,
        {magiq_comparisons_attributes: 
          [:id, :comparable_id, :comparable_type, :title, :notes, :comparison_method, :appraisal_id,
           :position, :score, :score_n, :rank]
        })
    end
end
