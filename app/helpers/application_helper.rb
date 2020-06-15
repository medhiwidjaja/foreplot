module ApplicationHelper

  def logo
    image_tag("foreplot.png", alt: "FOREPLOT")
  end

  # For subnavbar menu
  def link_status(link, options={ :disabled => false })
    status = session[:link] == link ? 'active' : ''
    status += options[:disabled] ? ' disable' : ''
  end

  # For error messages in alert
  def inflectize(n, noun)
    if n == 1
      noun
    else
      noun.pluralize
    end
  end

  def description_snippet(description, len=100)
    unless description.blank?
      doc = Nokogiri::HTML::DocumentFragment.parse description
      doc.css("h1,h2,h3,h4,h5,h6").each {|h| h.name = 'h5'}
      doc.css('img').remove
      doc.css('br').remove
      #doc.to_html.truncate(len)
      doc.to_html
    end
  end

  def pic_snippet(description)
    unless description.blank?
      pic_node = Nokogiri::HTML(description).at_css('img')
      pic_node[:src] unless pic_node.nil?
    end
  end
  
  # For layout
  def has_left_frame?
    @has_left_frame.nil? ? 
      true : # <= default, change to preference
      @has_left_frame
  end

  def has_right_frame?
    @has_right_frame.nil? ? 
      true : # <= default, change to preference
      @has_right_frame
  end

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

  private

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
                                text.scan(regex).join(zero_width_space)
  end
end
