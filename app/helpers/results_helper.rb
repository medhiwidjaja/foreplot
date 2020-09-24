module ResultsHelper
  include ApplicationHelper

  def link_or_text(is_label, path, text)
    return content_tag(:li, content_tag(:a, text), class: 'active') if is_label
    
    content_tag :li, link_to(text, path)
  end
end