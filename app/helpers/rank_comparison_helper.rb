module RankComparisonHelper
  include ApplicationHelper
  
  def sortable_form_fields(form)
    form.fields_for :magiq_comparisons do |mc_fields|
      content_tag :li, class:'rank-item', id:mc_fields.object.id do
        content_tag(:strong, mc_fields.object.title, style:"margin-left:5px") +
        mc_fields.hidden_field(:id) +
        mc_fields.hidden_field(:title) +
        mc_fields.hidden_field(:rank, class:'order') +
        mc_fields.hidden_field(:comparable_id) +
        mc_fields.hidden_field(:comparable_type)
      end unless mc_fields.object.persisted?
    end
  end

  def rank_barchart(rank_method:, num_rank:)
    rank_table = Foreplot::Magiq::OrdinalScore.send "#{rank_method.to_s}_table", num_rank

    content_tag(:ul, class:'dist-table') do
      (0..num_rank-1).map do |i|
        content_tag(:li) do
          content_tag(:div, class:'progress') do
            content_tag(:div, "", class:'bar', style:"width: #{rank_table[i]*100}%") +
            content_tag(:div, class:'bar-label') do
              number_to_percentage(rank_table[i]*100, precision: 0)
            end
          end
        end
      end.join('').html_safe
    end
  end

  
  def radio_button_for_rank_method(rank_method, appraisal_rank_method, form)
    rank_method = rank_method.to_s
    checked = appraisal_rank_method.present? ? appraisal_rank_method==rank_method : rank_method=='rank_order_centroid'
    form.label "rank_method_#{rank_method}".to_sym, class:'radio' do
      form.radio_button(:rank_method, rank_method, checked: checked) +
      rank_method.to_s.titlecase
    end
  end
  
end
