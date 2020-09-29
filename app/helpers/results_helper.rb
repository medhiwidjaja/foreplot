module ResultsHelper
  include ApplicationHelper

  def link_or_text(label, path, text)
    return content_tag(:li, content_tag(:a, text), class: 'active') if controller_name == label
    
    content_tag :li, link_to(text, path)
  end
end