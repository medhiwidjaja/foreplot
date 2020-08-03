module ComparisonHelper
  include ApplicationHelper

  # For Toolbar in Criteria and Ratings
  def link_to_new_comparison_method(comparison_method, criterion_id, member_id, options={}, readonly=false)
    class_option = options[:class]
    case comparison_method
    when 'MagiqComparison'
      link_to 'Rank compare', new_criterion_magiq_comparison_path(criterion_id, member_id: member_id), class: class_option
    when 'DirectComparison'
      link_to 'Direct compare', new_criterion_direct_comparison_path(criterion_id, member_id: member_id), class: class_option
    when 'PairwiseComparison'
      link_to 'Pairwise compare', new_criterion_pairwise_comparison_path(criterion_id, member_id: member_id), class: class_option
    end
  end

  def link_to_edit_comparison_method(comparison, options={}, readonly=false)
    class_option = options[:class]
    case comparison.type
    when 'MagiqComparison'
      link_to 'Rank compare', edit_criterion_magiq_comparison_path(criterion_id, comparison.id), class: class_option
    when 'DirectComparison'
      link_to 'Direct compare', edit_criterion_direct_comparison_path(criterion_id, comparison.id), class: class_option
    when 'PairwiseComparison'
      link_to 'Pairwise compare', edit_criterion_pairwise_comparison_path(criterion_id, comparison.id), class: class_option
    end
  end

end