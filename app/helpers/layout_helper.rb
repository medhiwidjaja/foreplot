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

  def article_menu(article=nil)
    render partial: "shared/app_menu", locals: {article: article}
  end

  # For subnavbar menu
  def link_status(link, options={ :disabled => false })
    status = link.include?(controller_name) ? 'active' : ''
    status += options[:disabled] ? ' disable' : ''
  end

end