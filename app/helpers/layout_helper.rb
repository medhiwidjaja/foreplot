module LayoutHelper
  include ApplicationHelper

  APPTITLE = "Foreplot: "
  
  def page_title(title)
    content_for(:title) { APPTITLE + title.to_s }
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

end