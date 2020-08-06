module ComparisonHelper
  include ApplicationHelper

  # For Toolbar in Criteria and Ratings
  def link_to_new_comparison_method(comparison_method, criterion_id, member_id, options={}, readonly=false)
    class_option = options[:class]
    case comparison_method
    when 'MagiqComparison'
      link_to 'Rank compare', criterion_new_magiq_comparisons_path(criterion_id, member_id: member_id), class: class_option
    when 'DirectComparison'
      link_to 'Direct compare', criterion_new_direct_comparisons_path(criterion_id, member_id: member_id), class: class_option
    when 'PairwiseComparison'
      link_to 'Pairwise compare', criterion_new_pairwise_comparisons_path(criterion_id, member_id: member_id), class: class_option
    end
  end

  def link_to_edit_comparison_method(comparison, criterion_id, member_id,options={}, readonly=false)
    class_option = options[:class]
    case comparison.type
    when 'MagiqComparison'
      link_to 'Rank compare', criterion_edit_magiq_comparisonspath(criterion_id, member_id: member_id), class: class_option
    when 'DirectComparison'
      link_to 'Direct compare', criterion_edit_direct_comparisons_path(criterion_id, member_id: member_id), class: class_option
    when 'PairwiseComparison'
      link_to 'Pairwise compare', criterion_edit_pairwise_comparison_path(criterion_id, member_id: member_id), class: class_option
    end
  end

end