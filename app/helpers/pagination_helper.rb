module PaginationHelper
  include ApplicationHelper
  # This will make will_paginate work with Twitter Bootstrap
  class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, :rel => rel_value(page)), 
          :class => ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), 
          :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
  end

  # This will make will_paginate work with Twitter Bootstrap
  def page_navigation_links(pages, param=:page)
    will_paginate(pages, :class => 'pagination', 
                         :inner_window => 2, 
                         :outer_window => 0,
                         :param_name => param,    # Needed for pages with multiple models
                         :renderer => BootstrapLinkRenderer, 
                         :previous_label => '&larr;'.html_safe, 
                         :next_label => '&rarr;'.html_safe)
  end
end