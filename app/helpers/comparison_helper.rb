module ComparisonHelper
  include ApplicationHelper

  # For Toolbar in Criteria and Ratings
  def link_to_comparison_method(comparison_method, presenter, options={})
    class_option = options[:class]
    criterion_id = presenter.criterion.id
    member_id = presenter.member_id
    if presenter.appraisal.present? && presenter.appraisal.persisted?
      case comparison_method
      when 'MagiqComparison'
        link_to 'Rank method', criterion_edit_magiq_comparisons_path(criterion_id, member_id: member_id), class: class_option
      when 'DirectComparison'
        link_to 'Direct method', criterion_edit_direct_comparisons_path(criterion_id, member_id: member_id), class: class_option
      when 'AHPComparison'
        link_to 'Pairwise method', criterion_edit_ahp_comparisons_path(criterion_id, member_id: member_id), class: class_option
      end
    else
      case comparison_method
      when 'MagiqComparison'
        link_to 'Rank method', criterion_new_magiq_comparisons_path(criterion_id, member_id: member_id), class: class_option
      when 'DirectComparison'
        link_to 'Direct method', criterion_new_direct_comparisons_path(criterion_id, member_id: member_id), class: class_option
      when 'AHPComparison'
        link_to 'Pairwise method', criterion_new_ahp_comparisons_path(criterion_id, member_id: member_id), class: class_option
      end
    end
  end
  
  def evaluated_items_title(criterion)
    criterion.leaf? ? 'Alternatives' : 'Sub-criteria'
  end
end