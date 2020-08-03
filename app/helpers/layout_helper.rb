module LayoutHelper
  include ApplicationHelper

  APPTITLE = ""
  
  def page_title(title)
    content_for(:title) { APPTITLE + title.to_s }
  end

  def turbolinks_no_cache
    content_for(:head) { '<meta name="turbolinks-cache-control" content="no-cache">' }
  end

  # for use with TurbolinksCacheControl concern
  def turbolinks_cache_control_meta_tag
    tag :meta, name: 'turbolinks-cache-control', content: @turbolinks_cache_control || 'cache'
  end

  def flash_class(level)
    case level
      when 'info' then "alert alert-info"  
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
  end

  def article_menu(article)
    render partial: "shared/app_menu", locals: {article: article}
  end

  # For Toolbar in Criteria and Ratings
  def link_to_comparison_method(comparison_method, criterion_id, member_id, options={}, readonly=false)
    label = readonly ? 'View comparison' : "Compare by #{comparison_method.upcase} method"
    class_option = options[:class]
    case comparison_method
    when 'magiq'
      link_to label, criterion_appraisal_rank_path(criterion_id), class: class_option
    when 'direct'
      link_to label, criterion_appraisal_direct_path(criterion_id), class: class_option
    when 'ahp'
      link_to label, criterion_appraisal_pairwise_path(criterion_id), class: class_option
    end
  end

end