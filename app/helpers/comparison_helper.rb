module ComparisonHelper
  include ApplicationHelper

  # For Toolbar in Criteria and Ratings
  def link_to_comparison_method(comparison_method, appraisal, options={}, readonly=false)
    criterion_id = appraisal.criterion_id
    member_id = appraisal.member_id
    class_option = options[:class]
    if appraisal.persisted?
      case comparison_method
      when 'MagiqComparison'
        link_to 'Rank compare', criterion_edit_magiq_comparisons_path(criterion_id, member_id: member_id), class: class_option
      when 'DirectComparison'
        link_to 'Direct compare', criterion_edit_direct_comparisons_path(criterion_id, member_id: member_id), class: class_option
      when 'PairwiseComparison'
        link_to 'Pairwise compare', criterion_edit_pairwise_comparisons_path(criterion_id, member_id: member_id), class: class_option
      end
    else
      case comparison_method
      when 'MagiqComparison'
        link_to 'Rank compare', criterion_new_magiq_comparisons_path(criterion_id, member_id: member_id), class: class_option
      when 'DirectComparison'
        link_to 'Direct compare', criterion_new_direct_comparisons_path(criterion_id, member_id: member_id), class: class_option
      when 'PairwiseComparison'
        link_to 'Pairwise compare', criterion_new_pairwise_comparisons_path(criterion_id, member_id: member_id), class: class_option
      end
    end
  end
end