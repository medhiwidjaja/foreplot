
class AHPComparisonsController < ApplicationController
  include ComparisonConcern

  def new
    @form = AHPComparisonsForm.new @appraisal
  end

  def edit
    @form = AHPComparisonsForm.new @appraisal
  end

  def create
    @form = AHPComparisonsForm.new @appraisal, ahp_comparisons_form_params
    if @form.submit
      redirect_to @criterion, notice: 'AHP comparisons saved'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @form = AHPComparisonsForm.new @appraisal, ahp_comparisons_form_params
    if @form.submit
      redirect_to @criterion, notice: 'AHP comparisons updated'
    else
      flash[:error] = @form.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

    def ahp_comparisons_form_params
      params.require(:ahp_comparisons_form).permit(:criterion_id, :member_id, :appraisal_method, 
        {ahp_comparisons_attributes: 
          [:id, :comparable_id, :comparable_type, :title, :notes, :comparison_method, :appraisal_id,
           :score, :score_n, :rank]
        },
        {pairwise_comparisons_attributes: 
          [:id, :comparable1_id, :comparable1_type, :comparable2_id, :comparable2_type,:value]
        }
      )
    end
end
